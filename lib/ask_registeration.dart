import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'askregister.dart';
import 'package:Shrine/services/checklogin.dart';
import 'services/services.dart';
import 'self_register_emp.dart';
import 'register_org.dart';

class AskRegisteration extends StatefulWidget {
  AskRegisteration({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AskRegisteration createState() => new _AskRegisteration();
}

class _AskRegisteration extends State<AskRegisteration> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _crn;
  int val=1;
  bool loader = false;
  bool add_org=false;
  bool add_emp=true;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  Map<String, dynamic> res;
  FocusNode crn = new FocusNode();


  @override
  void initState() {
    _crn = new TextEditingController();
    super.initState();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  setLocal(name,orgid) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('org_name',name);
    await prefs.setString('orgdir',orgid);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text("VTLTransport", style: new TextStyle(fontSize: 20.0)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AskRegisterationPage()),
            );
          },
        ),
        backgroundColor: Colors.teal,
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: loader
              ? runloader()
              : new Form(
                  key: _formKey,
                  autovalidate: true,
                  child: new ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .16),
                      ),
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                         /* new Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.teal,
                                value: 2,
                                groupValue: val,
                                onChanged: (newValue) {
                                  setState(() {
                                    add_org=true;
                                    add_emp=false;
                                    val = newValue;
                                  });
                                },
                              ),
                              new Text(
                                'Register Company',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),*/
                          add_org==true?new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.12),
                                child: new Text(
                                  'Add Company',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width * 0.7,
                                height: 45.0,
                                child:Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width * 0.12),
                                  child: RaisedButton(
                                    child: Text(
                                      'Click to register company',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => MyApp()),
                                      );
                                    },
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ),
                            ],
                          ):Center(),
                        ],
                      ),
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.teal,
                                value: 1,
                                groupValue: val,
                                onChanged: (newValue) {
                                  setState(() {
                                    add_emp=true;
                                    add_org=false;
                                    val = newValue;
                                  });
                                },
                              ),
                              new Text(
                                'Register Employee',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          add_emp==true?Column(
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              /*  Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.12,
                                  bottom: 3.0),
                              child: new Text('Add Employee Profile'),
                            ),
*/

                              Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.12,
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  child:new TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter CRN';
                                      }else if(value!='145371348'){
                                        return 'Please enter correct CRN';
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Company Reference Number',
                                    ),
                                     controller: _crn,
                                    //focusNode: __cname,
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.12,
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child:new RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Note: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 15.0)),
                                          TextSpan(
                                              text:
                                              'CRN (Company Reference Number) is only available after company registration.'
                                                  'You can get the CRN from mail sent to the admin( who has registered the company).',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54)),
                                          TextSpan(
                                              text: ' Register Company ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                                fontSize: 16.0,
                                              )),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width * 0.7,
                                height: 45.0,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                      MediaQuery.of(context).size.width * 0.12),
                                  child: RaisedButton(
                                    child: Text(
                                      'Next',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {

                                      if (!_formKey.currentState.validate()) {
                                     /*   Scaffold
                                            .of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text(
                                                'Please enter the CRN')));*/
                                        return null;
                                      } else {
                                        checkOrganization(_crn.text).then((res){
                                          print('function called.....');
                                          print(res['sts']);
                                          if(res['sts'].toString()=='0'){
                                            showDialog(context: context, child:
                                            new AlertDialog(
                                              title: new Text("Alert"),
                                              content: new Text("Please enter correct CRN"),
                                            ));
                                          return null;
                                          }else{
                                            setLocal(res['Name'].toString(),res['Id'].toString());
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelfRegister(title:res['Name'])),
                                            );
                                          }



                                        }).catchError((onError){
                                          showDialog(context: context, child:
                                          new AlertDialog(
                                            title: new Text("Alert"),
                                            content: new Text("Unable to connect server"),
                                          ));
                                          return null;

                                        });

                                      }
                                    },
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ),
                            ],
                          ):Center(),
                        ],
                      ),

                    ],
                  ))),
    );
  }

  runloader() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }
}
