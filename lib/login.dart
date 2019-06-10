// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// this is testing
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'home.dart';
import 'package:Shrine/model/user.dart';
import 'package:Shrine/services/checklogin.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'forgot_password.dart';
import 'askregister.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String barcode = "";
  final _formKey = GlobalKey<FormState>();
  String loginuser="";

  bool loader = false;
  FocusNode textSecondFocusNode = new FocusNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loginuser = prefs.getString('username') ?? "";
      _usernameController.text=loginuser;
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:new Builder(
        builder: (BuildContext context) {
          return new Center(
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Column(
                    children: <Widget>[
                      Image.asset(
                          'assets/logo.png', height: 150.0, width: 180.0,),
                      (loader) ? Center(child : new CircularProgressIndicator()) : SizedBox(height: 2.0),
                      /*Text('Log In', style: new TextStyle(fontSize: 20.0)),*/
                    ],
                  ),
                  /*SizedBox(height: 10.0),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if(loader)
                            return null;

                          setState(() {
                            loader = true;
                          });
                          scan().then((onValue){
                            print("******************** QR value **************************");
                            print(onValue);
                            if(onValue!='error') {
                              markAttByQR(onValue, context);
                            }else {
                              setState(() {
                                loader = false;
                              });
                            }
                          });
                        },
                        child:  Image.asset(
                          'assets/qr.png', height: 45.0, width: 45.0,
                        ),
                      ),
                    ],
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(textSecondFocusNode);
                    },
                    controller: _usernameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the Username';
                      }
                    },
                  ),
                  // spacer
                  SizedBox(height: 12.0),
                  // [Password]
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    focusNode: textSecondFocusNode,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter password';
                      }
                    },
                    onFieldSubmitted: (String value) {
                      if (_formKey.currentState.validate()) {
                        login(_usernameController.text,_passwordController.text,context);
                      }
                    },
                  ),

                  SizedBox(height: 5.0),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            shape: Border.all(color: Colors.black54),
                            child: Text('CANCEL'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AskRegisterationPage()),
                              );
                            },
                          ),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width*0.25,
                            child:RaisedButton(
                              child: Text('LOGIN',style: TextStyle(color: Colors.white),),
                              color: Colors.orangeAccent,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  login(_usernameController.text,_passwordController.text,context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),

                 /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width*0.3,
                        child:RaisedButton(
                        child: Text('Scan QR code'),
                        color: Colors.orangeAccent,
                        onPressed: () {
                         scan().then((onValue){
                            print(onValue);
                            markAttByQR(onValue,context);
                         });
                        },
                      ),
                      ),
                    ],
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        child: new Text("Forgot Password?", style: new TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            decoration: TextDecoration.underline),),
                        onTap: () {
                          Navigator.push(
                              context, new MaterialPageRoute(builder: (BuildContext context) => ForgotPassword()));
                        },
                      ),
                      SizedBox(width: 19.0,)
                    ],
                  )
                ],
              ),
            ),
          )
          ,
          );
        },
      ),
    );

  }

  markAttByQR(var qr, BuildContext context) async{
    Login dologin = Login();
    setState(() {
      loader = true;
    });
    var islogin = await dologin.markAttByQR(qr,context);
    print(islogin);
    if(islogin=="success"){
      setState(() {
        loader = false;
      });
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance marked successfully.")));
    }else if(islogin=="failure"){
      setState(() {
        loader = false;
      });
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Invalid login credentials")));
    }else if(islogin=="imposed"){
      setState(() {
        loader = false;
      });
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance is already marked")));
    }else{
      setState(() {
        loader = false;
      });
      /*Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance is already marked")));*/
    }
  }

  login(var username,var userpassword, BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    var user = User(username,userpassword);
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      Login dologin = Login();
      setState(() {
        loader = true;
      });
      var islogin = await dologin.checkLogin(user);
      print(islogin);
      if(islogin=="success"){
        prefs.setString('username', username);
        /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );*/
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,
        );
      }else if(islogin=="failure"){
        setState(() {
          loader = false;
        });
        Scaffold.of(context)
            .showSnackBar(
            SnackBar(content: Text("Invalid login credentials")));
      }else{
        setState(() {
          loader = false;
        });
        Scaffold.of(context)
            .showSnackBar(
            SnackBar(content: Text("Poor network connection.")));
      }
    }else{
      showDialog(context: context, child:
      new AlertDialog(

        content: new Text("Internet connection not found!."),
      )
      );
    }

  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
        return "pemission denied";
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
        return "error";
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
      return "error";
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
      return "error";
    }
  }

}


