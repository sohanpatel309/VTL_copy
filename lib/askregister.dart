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
import 'login.dart';
import 'ask_registeration.dart';
import 'self_register_emp.dart';
class AskRegisterationPage extends StatefulWidget {
  @override
  _AskRegisterationPageState createState() => _AskRegisterationPageState();
}

class _AskRegisterationPageState extends State<AskRegisterationPage> {
  String barcode = "";
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loader = false;

  FocusNode textSecondFocusNode = new FocusNode();
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
                        SizedBox(height: 25.0),
                        Center(child:Text("Surest way to Employee Attendance",style: new TextStyle(color: Colors.black87,fontSize: 19.0,fontWeight: FontWeight.bold))),
                        SizedBox(height: 10.0),
                        Center(child:Text('4 way Check - User Id + Time + Selfie + Location',style: new TextStyle(color: Colors.black54,fontWeight:FontWeight.bold,fontSize: 14.0,))),
                        Column(
                          children: <Widget>[
                            Image.asset(
                                'assets/landing.png', height: 300.0, width: 300.0),
                            (loader) ? Center(child : new CircularProgressIndicator()) : SizedBox(height: 2.0),
                            SizedBox(height: 60.0),
                          ],
                        ),



                       SizedBox(height: 5.0),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width*0.8,
                              height: 45.0,
                              child:RaisedButton(
                                child: Text('Already registered? Sign In',style: new TextStyle(color: Colors.white,fontSize: 15.0)),
                                color: Colors.orangeAccent,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width*0.8,
                              height: 45.0,
                              child:FlatButton(
                                shape: Border.all(color: Colors.orangeAccent),
                                child: Text('Not registered? Sign Up',style: new TextStyle(color: Colors.orangeAccent,fontSize: 15.0),),
                                color: Colors.white,
                                onPressed: () {
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AskRegisteration()),
                                   // MaterialPageRoute(builder: (context) => MyApp()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance is already marked")));
    }
  }

  login(var username,var userpassword, BuildContext context) async{
    var user = User(username,userpassword);
    Login dologin = Login();
    setState(() {
      loader = true;
    });
    var islogin = await dologin.checkLogin(user);
    print(islogin);
    if(islogin=="success"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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

// TODO: Add AccentColorOverride (103)
