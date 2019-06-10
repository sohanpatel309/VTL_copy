// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:Shrine/services/fetch_location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'askregister.dart';
import 'package:Shrine/services/gethome.dart';
import 'package:Shrine/services/saveimage.dart';
import 'package:Shrine/model/timeinout.dart';
import 'attendance_summary.dart';
import 'drawer.dart';
import 'timeoff_summary.dart';
import 'package:Shrine/services/services.dart';
import 'leave.dart';
import 'package:Shrine/services/newservices.dart';
import 'home.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart';
import 'punchlocation_summary.dart';
import 'settings.dart';
import 'profile.dart';
import 'reports.dart';
import 'services/services.dart';
import 'package:connectivity/connectivity.dart';

// This app is a stateful, it tracks the user's current choice.
class PunchLocation extends StatefulWidget {
  @override
  _PunchLocation createState() => _PunchLocation();
}

class _PunchLocation extends State<PunchLocation> {
  StreamLocation sl = new StreamLocation();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  //final _clientname = TextEditingController();
  final _trailer = TextEditingController();
  final _pro = TextEditingController();
  final _start = TextEditingController();
  final _finish = TextEditingController();
  final _remarkin = TextEditingController();
  /*var _defaultimage =
      new NetworkImage("http://ubiattendance.ubihrm.com/assets/img/avatar.png");*/
  var profileimage;
  bool _checkLoaded = true;
  int _currentIndex = 1;
  String userpwd = "new";
  String newpwd = "new";
  int Is_Delete=0;
  bool _visible = true;
  String location_addr = "";
  String location_addr1 = "";
  String streamlocationaddr = "";
  String admin_sts = '0';
  String mail_varified = '1';
  String lat = "";
  String long = "";
  String act = "";
  String act1 = "";
  int alertdialogcount = 0;
  Timer timer;
  Timer timer1;
  int response;
  final Widget removedChild = Center();
  String fname = "",
      lname = "",
      empid = "",
      cid = "",
      email = "",
      status = "",
      orgid = "",
      orgdir = "",
      sstatus = "",
      org_name = "",
      desination = "",
      desinationId = "",
      profile,
      latit = "",
      longi = "";
  String aid = "";
  String client='0';
  String shiftId = "";
  String dropdownValue = 'DRP';
  List<Widget> widgets;


  @override
  void initState() {
    super.initState();

    initPlatformState();
    setLocationAddress();
    startTimer();

  }


  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
  startTimer() {
    const fiveSec = const Duration(seconds: 5);
    int count = 0;
    timer = new Timer.periodic(fiveSec, (Timer t) {
      //print("timmer is running");
      count++;
      //print("timer counter" + count.toString());
      setLocationAddress();
      if (stopstreamingstatus) {
        t.cancel();
        //print("timer canceled");
      }
    });
  }

  startTimer1() {
    const fiveSec = const Duration(seconds: 1);
    int count = 0;
    timer1 = new Timer.periodic(fiveSec, (Timer t) {
      print("timmer is running");
    });
  }

  setLocationAddress() async {
    setState(() {
      streamlocationaddr = globalstreamlocationaddr;
      if (list != null && list.length > 0) {
        lat = list[list.length - 1]['latitude'].toString();
        long = list[list.length - 1]["longitude"].toString();
        if (streamlocationaddr == '') {
          streamlocationaddr = lat + ", " + long;
        }
      }
      if(streamlocationaddr == ''){
        sl.startStreaming(5);
        startTimer();
      }
      //print("home addr" + streamlocationaddr);
      //print(lat + ", " + long);

      //print(stopstreamingstatus.toString());
    });
  }

  launchMap(String lat, String long) async {
    String url = "https://maps.google.com/?q=" + lat + "," + long;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //print('Could not launch $url');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {

    /*await availableCameras();*/
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    desinationId = prefs.getString('desinationId') ?? '';
    response = prefs.getInt('response') ?? 0;


    if (response == 1) {
      Loc lock = new Loc();
      location_addr = await lock.initPlatformState();
      Home ho = new Home();
      act = await ho.checkTimeIn(empid, orgdir);
      ho.managePermission(empid, orgdir, desinationId);
      // //print(act);
      ////print("this is-----> "+act);
      ////print("this is main "+location_addr);
      setState(() {
        Is_Delete = prefs.getInt('Is_Delete') ?? 0;
        newpwd = prefs.getString('newpwd') ?? "";
        userpwd = prefs.getString('usrpwd') ?? "";
        print("New pwd"+newpwd+"  User ped"+userpwd);
        location_addr1 = location_addr;
        admin_sts = prefs.getString('sstatus').toString() ?? '0';
        mail_varified = prefs.getString('mail_varified').toString() ?? '0';
        alertdialogcount = globalalertcount;
        response = prefs.getInt('response') ?? 0;
        fname = prefs.getString('fname') ?? '';
        lname = prefs.getString('lname') ?? '';
        empid = prefs.getString('empid') ?? '';
        email = prefs.getString('email') ?? '';
        status = prefs.getString('status') ?? '';
        orgid = prefs.getString('orgid') ?? '';
        orgdir = prefs.getString('orgdir') ?? '';
        org_name = prefs.getString('org_name') ?? '';
        desination = prefs.getString('desination') ?? '';
        profile = prefs.getString('profile') ?? '';
        profileimage = new NetworkImage(profile);
        // //print("1-"+profile);
        profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        });
        // //print("2-"+_checkLoaded.toString());
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        aid = prefs.getString('aid') ?? "";
        shiftId = prefs.getString('shiftId') ?? "";
        ////print("this is set state "+location_addr1);
        act1 = act;
        // //print(act1);
        streamlocationaddr = globalstreamlocationaddr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (response == 0 || userpwd!=newpwd || Is_Delete!=0) ? new AskRegisterationPage() : getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget() {
    return new WillPopScope(
        onWillPop: () async => true,
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(org_name, style: new TextStyle(fontSize: 20.0)),
              ],
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.teal,
            // backgroundColor: Color.fromARGB(255,63,163,128),
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (newIndex) {
              if (newIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
                return;
              } else if (newIndex == 0) {
                (admin_sts == '1')
                    ? Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Reports()),
                )
                    : Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );

                return;
              }else if (newIndex == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                return;
              }

              setState(() {
                _currentIndex = newIndex;
              });
            }, // this will be set when a new tab is tapped
            items: [
              (admin_sts == '1')
                  ? BottomNavigationBarItem(
                icon: new Icon(
                  Icons.library_books,
                ),
                title: new Text('Reports'),
              )
                  : BottomNavigationBarItem(
                icon: new Icon(
                  Icons.person,
                ),
                title: new Text('Profile'),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.home,color: Colors.black54,),
                title: new Text('Home',style:TextStyle(color: Colors.black54,)),
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                  ),
                  title: Text('Settings'))
            ],
          ),

          endDrawer: new AppDrawer(),
          body: (act1 == '') ? Center(child: loader()) : checkalreadylogin(),
        ));
  }

  checkalreadylogin() {

    ////print("---->"+response.toString());
    if (response == 1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          (streamlocationaddr != '') ? mainbodyWidget() : refreshPageWidgit(),
          //(false) ? mainbodyWidget() : refreshPageWidgit(),
          underdevelopment()
        ],
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AskRegisterationPage()),
            (Route<dynamic> route) => false,
      );
    }
  }

  refreshPageWidgit() {
    if (location_addr1 != "PermissionStatus.deniedNeverAsk") {
      return new Container(
        child: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 20.0,),
                    Icon(
                      Icons.all_inclusive,
                      color: Colors.teal,
                    ),
                    Text(
                      " Fetching location, please wait..",
                      style: new TextStyle(fontSize: 20.0, color: Colors.teal),
                    )
                  ]),
              SizedBox(height: 15.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 20.0,),
                    Text(
                      "Note: ",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      " If Location not being fetched automatically?",
                      style: new TextStyle(fontSize: 12.0, color: Colors.black),
                      textAlign: TextAlign.left,
                    ),

                  ]),

              FlatButton(
                child: new Text(
                  "Fetch Location now",
                  style: new TextStyle(
                      color: Colors.teal, decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  sl.startStreaming(5);
                  startTimer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Location permission is restricted from app settings, click "Open Settings" to allow permission.',
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 14.0, color: Colors.red)),
            RaisedButton(
              child: Text('Open Settings'),
              onPressed: () {
                SimplePermissions.openSettings();
              },
            ),
          ]);
    }
  }

  loader() {
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

  underdevelopment() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.android,
                color: Colors.teal,
              ),
              Text(
                "Under development",
                style: new TextStyle(fontSize: 30.0, color: Colors.teal),
              )
            ]),
      ),
    );
  }

  poorNetworkWidget() {
    return Container(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.error,
                      color: Colors.teal,
                    ),
                    Text(
                      "Poor network connection.",
                      style: new TextStyle(fontSize: 20.0, color: Colors.teal),
                    ),
                  ]),
              SizedBox(height: 5.0),
              FlatButton(
                child: new Text(
                  "Refresh location",
                  style: new TextStyle(
                      color: Colors.teal, decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  sl.startStreaming(5);
                  startTimer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PunchLocation()),
                  );
                },
              ),
            ]),
      ),
    );
  }

  mainbodyWidget() {
    ////to do check act1 for poor network connection

    if (act1 == "Poor network connection") {
      return poorNetworkWidget();
    } else {
      //return new Expanded(
        return new Container(
          child: SafeArea(
            child: Form(
            key:_formKey,
            child: ListView(
              //scrollDirection: Axis.vertical,
              physics:BouncingScrollPhysics(),
              children: <Widget>[
                Container(
                  // foregroundDecoration: BoxDecoration(color:Colors.red ),
                  height: MediaQuery.of(context).size.height * 0.90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height * .02),
                      //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
                      // SizedBox(height: 5.0),
                      getClients_DD(),

                      Container(
                        child: TextFormField(
                          controller: _pro,
                          decoration: InputDecoration(
                            labelText: 'Pro# (Optional)',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Icon(
                                Icons.attachment,
                                color: Colors.grey,
                              ), // icon is 48px widget.
                            ),
                          ),
                          /*validator: (String arg) {
                            if(arg=='')
                              return 'Project Number is mandatory';
                            else
                              return null;
                          },*/
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          controller: _trailer,
                          //keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Trailer# (Optional)',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Icon(
                                Icons.attachment,
                                color: Colors.grey,
                              ), // icon is 48px widget.
                            ),
                          ),
                         /* validator: (String arg) {
                            if(arg=='')
                              return 'Trailer Number is mandatory';
                            else
                              return null;
                          },*/
                        ),
                      ),
                      action_DD(),
                      //SizedBox(height: 10.0),
                      //Text('Odometer Start',style: TextStyle(fontWeight: FontWeight.bold,fontSize:18.0),textAlign: TextAlign.left),

                         /* Container(
                            child:Padding(
                              padding: const EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
                              child: TextFormField(
                                controller: _start,
                                keyboardType: TextInputType.number,
                                //maxLength: 7,
                                decoration: InputDecoration(
                                  labelText: 'Odometer Start',
                                  prefixIcon: Padding(
                                padding: EdgeInsets.all(1.0),
                                child: Icon(
                                  Icons.attachment,
                                  color: Colors.grey,
                                ), // icon is 48px widget.
                              ),
                                ),
                                validator: (String arg) {
                                  if(arg=='')
                                    return 'Odometer start is mandatory';
                                  else
                                    return null;
                                },
                              ),
                            ),

                          ),*/
                        /*  Flexible(
                            child:Padding(
                              padding: const EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
                              child: TextFormField(
                                controller: _finish,
                                keyboardType: TextInputType.number,
                                maxLength: 7,
                                decoration: InputDecoration(
                                  labelText: 'Finish',

                                ),
                                validator: (String arg) {
                                  if(arg.length!=7)
                                    return 'Odometer value must be of 7 digits';
                                  else
                                    return null;
                                },
                              ),
                            ),

                          ),*/


                      Container(
                        child:Padding(
                          padding: const EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
                          child: TextFormField(
                            controller: _remarkin,
                            //keyboardType: TextInputType.number,
                            //maxLength: 7,
                            decoration: InputDecoration(
                              labelText: 'Remarks (Optional)',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(1.0),
                                child: Icon(
                                  Icons.attachment,
                                  color: Colors.grey,
                                ), // icon is 48px widget.
                              ),
                            ),
                            /*validator: (String arg) {
                              if(arg=='')
                                return 'Odometer start is mandatory';
                              else
                                return null;
                            },*/
                          ),
                        ),

                      ),
                      //SizedBox(height: 1.0),
                      SizedBox(height: MediaQuery.of(context).size.height * .01),
                      // SizedBox(height: MediaQuery.of(context).size.height*.01),
                      (act1 == '') ? loader() : getMarkAttendanceWidgit(),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ),
        );

     // );

    }
  }

  getMarkAttendanceWidgit() {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
           // SizedBox(height: 35.0),
            getwidget(location_addr1),
          ]),
    );
  }
  getwidget(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Column(children: [

        Container(
            color: Colors.teal.withOpacity(0.1),
            height: MediaQuery.of(context).size.height * .15,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FlatButton(
                child: new Text('You are at: ' + streamlocationaddr,
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 14.0)),
                onPressed: () {
                  launchMap(lat, long);
                },
              ),
              new Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('Location not correct? ',style: TextStyle(color: Colors.teal),),
                    SizedBox(width: 5.0,),
                    new InkWell(
                      child: new Text(
                        "Refresh location",
                        style: new TextStyle(
                            color: Colors.teal,
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () {
                        startTimer();
                        sl.startStreaming(5);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PunchLocation()),
                        );
                      },
                    )
                  ],
                ),
              ),
            ])),
        SizedBox(height: MediaQuery.of(context).size.height * .02),
        ButtonTheme(
          minWidth: 120.0,
          height: 45.0,
          child: getVisitInButton(),
        ),
      ]);
    } else {
      return Column(children: [
        Text(
            'Location permission is restricted from app settings, click "Open Settings" to allow permission.',
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 14.0, color: Colors.red)),
        RaisedButton(
          child: Text('Open Settings'),
          onPressed: () {
            SimplePermissions.openSettings();
          },
        ),
      ]);
    }
    return Container(width: 0.0, height: 0.0);
  }

  getVisitInButton() {
    return RaisedButton(
      child: Text('VISIT IN',
          style: new TextStyle(fontSize: 22.0, color: Colors.white)),
      color: Colors.orangeAccent,
      onPressed: () {
        if (_formKey.currentState.validate()) {
         // print('client: ' + client);
          //print(_trailer.text);
          // if(_clientname.text=='') {
          /*if (client == '0') {
            showInSnackBar('Please insert client name first');
            return false;
          }*/ /*else if (_pro.text == '' || _pro.text == 0) {
            showInSnackBar('Please insert Project number first');
            return false;
          } */
         /* if (_trailer.text == '' || _trailer.text == '0') {
            showInSnackBar('Please insert trailer first');
            return false;
          } else if (_start.text == '' || _start.text == '0') {
            showInSnackBar('Please insert Odometer Start value');
            return false;
          }*/
         /* else if (_finish.text == '' || _finish.text== '0') {
            showInSnackBar('Please insert Odometer Finish value');
            return false;
          } else if (int.parse(_finish.text) <=int.parse(_start.text)) {
            showInSnackBar('Odometer Start value can not be greater than finish value');
            return false;
          } */
        // else
            saveVisitImage();
        }
      },
    );
  }

  Text getText(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Text('You are at: ' + addrloc,
          textAlign: TextAlign.center, style: new TextStyle(fontSize: 14.0));
    } else {
      return new Text(
          'Location access is denied. Enable the access through the settings.',
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 14.0, color: Colors.red));
      /*return new  Text('Location is restricted from app settings, click here to allow location permission and refresh', textAlign: TextAlign.center, style: new TextStyle(fontSize: 14.0,color: Colors.red));*/
    }
  }

  saveVisitImage() async {
    sl.startStreaming(5);
   // client = _clientname.text;
    MarkVisit mk = new MarkVisit(
        empid,client, streamlocationaddr, orgdir, lat, long, _start.text,_finish.text,_pro.text,_trailer.text,dropdownValue,_remarkin.text);
    /* mk1 = mk;*/

    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraExampleHome()),
      );*/
      SaveImage saveImage = new SaveImage();
      bool issave = false;
      setState(() {
        act1 = "";
      });
      issave = await saveImage.saveVisit(mk);
      ////print(issave);
      if (issave) {
        showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Visit punched successfully!"),
        )
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PunchLocationSummary()),
        );
        setState(() {
          act1 = act;
        });
      } else {
        showDialog(context: context, child:
        new AlertDialog(
          title: new Text("Warning!"),
          content: new Text("Problem while punching visit, try again."),
        )
        );
        setState(() {
          act1 = act;
        });
      }
    }else{
      showDialog(context: context, child:
      new AlertDialog(

        content: new Text("Internet connection not found!."),
      )
      );
    }


    /*SaveImage saveImage = new SaveImage();
    bool issave = false;
    setState(() {
      act1 = "";
    });
    issave = await saveImage.saveTimeInOut(mk);
    ////print(issave);
    if (issave) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
      setState(() {
        act1 = act;
      });
    } else {
      setState(() {
        act1 = act;
      });
    }*/
  }

/*  saveImage() async {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraApp()),
      );

  }*/

  resendVarification() async{
    NewServices ns= new NewServices();
    bool res = await ns.resendVerificationMail(orgid);
    if(res){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              content: Row( children:<Widget>[
                Text("Verification link has been sent to \nyour organization's registered Email."),
              ]
              )
          )
      );
    }
  }

////////////////////////////////////////////////////////////
  Widget getClients_DD() {
    return new FutureBuilder<List<Map>>(
        future: getClientsDDList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Container(
              //    width: MediaQuery.of(context).size.width*.45,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Client Name',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(
                      Icons.access_alarm,
                      color: Colors.grey,
                    ), // icon is 48px widget.
                  ),
                ),
                child: new DropdownButton<String>(
                  isDense: true,
                  style: new TextStyle(fontSize: 15.0, color: Colors.black),
                  value: client,
                  onChanged: (String newValue) {
                    setState(() {
                      client = newValue;
                    });
                  },
                  items: snapshot.data.map((Map map) {
                    return new DropdownMenuItem<String>(
                      value: map["Id"].toString(),
                      child: new SizedBox(
                          width: 200.0,
                          child: new Text(
                            map["Name"],
                          )),
                    );
                  }).toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // return loader();
          return new Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
              ),
              height: 20.0,
              width: 20.0,
            ),
          );
        });
  }
  Widget action_DD() {
    return new Container(
      //    width: MediaQuery.of(context).size.width*.45,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Choose Action',
          prefixIcon: Padding(
            padding: EdgeInsets.all(1.0),
            child: Icon(
              Icons.transfer_within_a_station,
              color: Colors.grey,
            ), // icon is 48px widget.
          ),
        ),
        child: DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['DRP', 'PU', 'DEL', 'SWITCH']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
////////////////////////////////////////////////////////////
}
