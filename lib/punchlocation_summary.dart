import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'home.dart';
import 'globals.dart' as globals;
import 'package:Shrine/services/services.dart';
import 'package:Shrine/services/newservices.dart';
import 'punchlocation.dart';
import 'reports.dart';
import 'profile.dart';
import 'settings.dart';
import 'globals.dart';
import 'visitdetails.dart';
import 'package:Shrine/services/saveimage.dart';

//import 'package:intl/intl.dart';

void main() => runApp(new PunchLocationSummary());

class PunchLocationSummary extends StatefulWidget {
  @override
  _PunchLocationSummary createState() => _PunchLocationSummary();
}

class _PunchLocationSummary extends State<PunchLocationSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String lat = "";
  String long = "";
  String desination = "";
  String profile = "";
  String org_name = "";
  String orgid = "";
  String empid = "";
  String admin_sts = '0';
  int _currentIndex = 1;
  String streamlocationaddr = "";
  StreamLocation sl = new StreamLocation();
  bool _isButtonDisabled = false;
  final _comments = TextEditingController();
  final _finish = TextEditingController();
  String latit, longi, location_addr1;
  Timer timer;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setLocationAddress();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      streamlocationaddr = globalstreamlocationaddr;
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '0';
      org_name = prefs.getString('org_name') ?? '';
      orgid = prefs.getString('orgid') ?? '';
      empid = prefs.getString('empid') ?? '';
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
      if (streamlocationaddr == '') {
        sl.startStreaming(5);
        startTimer();
      }
      //print("home addr" + streamlocationaddr);
      //print(lat + ", " + long);

      //print(stopstreamingstatus.toString());
    });
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

  // This widget is the root of your application.
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(
      value,
      textAlign: TextAlign.center,
    ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<bool> sendToHome() async {
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    //  return false;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => sendToHome(),
      child: new Scaffold(
        appBar: new AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(org_name, style: new TextStyle(fontSize: 20.0)),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          backgroundColor: Colors.teal,
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
            }
            if (newIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
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
              icon: new Icon(
                Icons.home,
                color: Colors.black54,
              ),
              title: new Text('Home',
                  style: TextStyle(
                    color: Colors.black54,
                  )),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                title: Text('Settings'))
          ],
        ),
        endDrawer: new AppDrawer(),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchLocation()),
            );
          },
          tooltip: 'Request TimeOff',
          child: new Icon(Icons.add),
        ),
        body: getWidgets(context),
      ),
    );
  }

  /////////////
  _showDialog(visit_id,start) async {
    sl.startStreaming(2);
    setState(() {
      if (list != null && list.length > 0) {
        latit = list[list.length - 1]['latitude'].toString();
        longi = list[list.length - 1]["longitude"].toString();
        location_addr1 = globalstreamlocationaddr;
      } else {
        latit = "0.0";
        longi = "0.0";
        location_addr1 = "";
      }
    });
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                /*new Container(
                  child: new TextFormField(
                    // maxLines: 3,
                    autofocus: true,
                    controller: _finish,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                        labelText: 'Odometer Finish ',
                        hintText: 'Odometer Finish Value'),
                    validator: (String arg) {
                      print(start);
                      if (arg == '')
                        return 'Odometer finish is mandatory';
                      else if (int.parse(arg.toString()) < int.parse(start))
                        return 'Odometer finish must be greater than start';
                      else
                        return null;
                    },
                  ),
                ),*/
                new Expanded(
                  child: new TextField(
                    maxLines: 3,
                    //autofocus: true,
                    controller: _comments,
                    decoration: new InputDecoration(
                        labelText: 'Visit Feedback ',
                        hintText: 'Visit Feedback (Optional)'),
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              shape: Border.all(color: Colors.black54),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _comments.text = '';
                _finish.text = '';
                Navigator.of(context, rootNavigator: true).pop();
              }),
          new RaisedButton(
              child: const Text(
                'PUNCH',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.orangeAccent,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  sl.startStreaming(5);
                  SaveImage saveImage = new SaveImage();
                  print('****************************>>');
                  print(streamlocationaddr.toString());
                  print(visit_id.toString());
                  print('00000000000');
                  print(_comments.text);
                  print('111111111111111');
                  print(latit + ' ' + longi);
                  print('22222222222222');
                  print('<<****************************');
                  Navigator.of(context, rootNavigator: true).pop();
                  saveImage
                      .saveVisitOut(
                          empid,
                          streamlocationaddr.toString(),
                          visit_id.toString(),
                          latit,
                          longi,
                          _comments.text,
                          orgid,
                          _finish.text)
                      .then((res) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PunchLocationSummary()),
                    );
                  }).catchError((ett) {
                    showInSnackBar('Unable to punch visit');
                  });
                  /*       //  Loc lock = new Loc();
                //   location_addr1 = await lock.initPlatformState();
                if(_isButtonDisabled)
                  return null;

                Navigator.of(context, rootNavigator: true).pop('dialog');
                setState(() {
                  _isButtonDisabled=true;
                });
                //PunchInOut(comments.text,'','empid', location_addr1, 'lid', 'act', 'orgdir', latit, longi).then((res){
                SaveImage saveImage = new SaveImage();
                 saveImage.visitOut(comments.text,visit_id,location_addr1,latit, longi).then((res){
print('visit out called for visit id:'+visit_id);
                /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PunchLocationSummary()),
                  );
*/


                }).catchError((onError){
                  showInSnackBar('Unable to punch visit');
                });
*/
                }
              })
        ],
      ),
    );
  }

  /////////////
  getWidgets(context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Container(
        padding: EdgeInsets.only(top: 12.0, bottom: 2.0),
        child: Center(
          child: Text("My Today's Visits",
              style: new TextStyle(
                fontSize: 22.0,
                color: Colors.teal,
              )),
        ),
      ),
      Divider(
        color: Colors.black54,
        height: 1.5,
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            child: Text(
              ' Client',
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            child: Text(
              'In',
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.30,
            child: Text(
              'Out',
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          /* SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.20,
                child:Text('Pro#',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),*/
        ],
      ),
      Divider(),
      Container(
        height: MediaQuery.of(context).size.height * 0.60,
        child: new FutureBuilder<List<Punch>>(
          future: getSummaryPunch(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    //   double h_width = MediaQuery.of(context).size.width*0.5; // screen's 50%
                    //   double f_width = MediaQuery.of(context).size.width*1; // screen's 100%
                    return new Column(children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: 38.0,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data[index].client.toString(),
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                ),
                                /*InkWell(
                                          child: Text('In: ' +
                                              snapshot.data[index]
                                                  .pi_loc.toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12.0)),
                                          onTap: () {
                                            goToMap(
                                                snapshot.data[index]
                                                    .pi_latit ,
                                                snapshot.data[index]
                                                    .pi_longi);
                                          },
                                        ),
                                        SizedBox(height:2.0),
                                        InkWell(
                                          child: Text('Out: ' +
                                              snapshot.data[index]
                                                  .po_loc.toString(),
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12.0),),
                                          onTap: () {
                                            goToMap(
                                                snapshot.data[index]
                                                    .po_latit,
                                                snapshot.data[index]
                                                    .po_longi);
                                          },
                                        ),*/

                                SizedBox(
                                  height: 10.0,
                                ),
                                snapshot.data[index].po_time == '-'
                                    ? Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: InkWell(
                                          child: new Container(
                                            //width: MediaQuery.of(context).size.width*0.30,
                                            height: 25.0,
                                            decoration: new BoxDecoration(
                                              color: Colors.orangeAccent,
                                              border: new Border.all(
                                                  color: Colors.white,
                                                  width: 2.0),
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      10.0),
                                            ),
                                            child: new Center(
                                              child: new Text(
                                                'Visit Out',
                                                style: new TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            _showDialog(snapshot.data[index].Id
                                                .toString(),snapshot.data[index].start.toString());
                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[index].pi_time.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                  InkWell(
                                    child: Text(
                                        snapshot.data[index].pi_loc.toString(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0)),
                                    onTap: () {
                                      goToMap(snapshot.data[index].pi_latit,
                                          snapshot.data[index].pi_longi);
                                    },
                                  ),
                                  /*Row(children: <Widget>[
                                            Text("In: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text(snapshot.data[index].pi_time
                                                .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                          ]),
                                          Row(children: <Widget>[
                                            Text("Out: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text(snapshot.data[index].po_time
                                                .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                          ]),*/
                                  /* Container(
                                            width: 62.0,
                                            height: 62.0,
                                            child: Container(
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            snapshot
                                                                .data[index]
                                                                .pi_img)
                                                    )
                                                )),),*/
                                ],
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[index].po_time.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                  InkWell(
                                    child: Text(
                                        snapshot.data[index].po_loc.toString(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0)),
                                    onTap: () {
                                      goToMap(snapshot.data[index].po_latit,
                                          snapshot.data[index].po_longi);
                                    },
                                  ),
                                  /*Row(children: <Widget>[
                                          Text("Odometer: ", style: TextStyle(fontWeight: FontWeight.bold)),

                                        ]),
                                        //Text("Odometer: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),),
                                        Row(children: <Widget>[
                                          //  Text("Odometer: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(snapshot.data[index].start
                                              .toString()+" - "+snapshot.data[index].finish
                                              .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                        ]),

                                        Row(children: <Widget>[
                                          Text("Action: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(snapshot.data[index].action
                                              .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                        ]),*/
                                  /*Row(children: <Widget>[
                                      Text("Pro#: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(snapshot.data[index].pro
                                          .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    ]),*/
                                  /*Row(children: <Widget>[
                                          Text("Trailer#: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(snapshot.data[index].trailer
                                              .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                        ]),
*/
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: new Container(
                                        //width: MediaQuery.of(context).size.width*0.30,
                                        height: 25.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.orangeAccent,
                                          border: new Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                        ),
                                        child: new Center(
                                          child: new Text(
                                            'View Details',
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Visitdetails(
                                                      mv: snapshot
                                                          .data[index])),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              )),
                          /*SizedBox(width: MediaQuery.of(context).size.width*0.02),
                                  Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.22,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Text(snapshot.data[index].pro
                                              .toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.0),),
                                          */ /*Container(
                                            width: 62.0,
                                            height: 62.0,
                                            child: Container(
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            snapshot
                                                                .data[index]
                                                                .po_img)
                                                    )
                                                )),),*/ /*
                                        ],
                                      )

                                  ),*/
                        ],
                        /*children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(height: 38.0,),
                                  SizedBox(width: MediaQuery.of(context).size.width*0.02),
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.33,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Text(snapshot.data[index].client
                                            .toString(), style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),),
                                        InkWell(
                                          child: Text('In: ' +
                                              snapshot.data[index]
                                                  .pi_loc.toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12.0)),
                                          onTap: () {
                                            goToMap(
                                                snapshot.data[index]
                                                    .pi_latit ,
                                                snapshot.data[index]
                                                    .pi_longi);
                                          },
                                        ),
                                        SizedBox(height:2.0),
                                        InkWell(
                                          child: Text('Out: ' +
                                              snapshot.data[index]
                                                  .po_loc.toString(),
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12.0),),
                                          onTap: () {
                                            goToMap(
                                                snapshot.data[index]
                                                    .po_latit,
                                                snapshot.data[index]
                                                    .po_longi);
                                          },
                                        ),
                                        snapshot.data[index].po_time=='-'?Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: InkWell(

                                            child: new Container(
                                              //width: 100.0,
                                              height: 25.0,
                                              decoration: new BoxDecoration(
                                                color: Colors.orangeAccent,
                                                border: new Border.all(color: Colors.white, width: 2.0),
                                                borderRadius: new BorderRadius.circular(10.0),
                                              ),
                                              child: new Center(child: new Text('Visit Out', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                                            ),
                                            onTap: (){
                                              _showDialog(snapshot.data[index].Id.toString());
                                            },),
                                        ):Container(),

                                        SizedBox(height: 10.0,),


                                      ],
                                    ),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width*0.02),
                                  Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.18,
                                      child: Column(
                                       */ /* crossAxisAlignment: CrossAxisAlignment
                                            .center,*/ /*
                                        children: <Widget>[
                                          Row(children: <Widget>[
                                            Text("In: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text(snapshot.data[index].pi_time
                                                .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                          ]),
                                          Row(children: <Widget>[
                                            Text("Out: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text(snapshot.data[index].po_time
                                                .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                          ]),
                                           */ /* Container(
                                            width: 62.0,
                                            height: 62.0,
                                            child: Container(
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            snapshot
                                                                .data[index]
                                                                .pi_img)
                                                    )
                                                )),),*/ /*

                                        ],
                                      )

                                  ),

                                  Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.30,
                                      child: Column(
                                       */ /* crossAxisAlignment: CrossAxisAlignment
                                            .center,*/ /*
                                        children: <Widget>[Row(children: <Widget>[
                                          Text("Odometer: ", style: TextStyle(fontWeight: FontWeight.bold)),

                                        ]),
                                        //Text("Odometer: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),),
                                        Row(children: <Widget>[
                                          //  Text("Odometer: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(snapshot.data[index].start
                                              .toString()+" - "+snapshot.data[index].finish
                                              .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                        ]),

                                        Row(children: <Widget>[
                                          Text("Action: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(snapshot.data[index].action
                                              .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                        ]),
                                        */ /*Row(children: <Widget>[
                                      Text("Pro#: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(snapshot.data[index].pro
                                          .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    ]),*/ /*
                                        Row(children: <Widget>[
                                          Text("Trailer#: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(snapshot.data[index].trailer
                                              .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                        ]),

                                        ],
                                      )

                                  ),

                                  Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.15,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Text(snapshot.data[index].pro
                                              .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                          */ /*Container(
                                            width: 62.0,
                                            height: 62.0,
                                            child: Container(
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            snapshot
                                                                .data[index]
                                                                .po_img)
                                                    )
                                                )),),*/ /*
                                        ],
                                      )

                                  ),
                                ],*/
                      ), //
                      /*Row(children: <Widget>[
                                SizedBox(width: MediaQuery.of(context).size.width*0.02),
                                Text("In: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)),
                                Text(snapshot.data[index].pi_time
                                    .toString()+" (",style: TextStyle(fontSize: 12.0)),
                                InkWell(
                                  child: Text(
                                      snapshot.data[index]
                                          .pi_loc.toString(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.0)),
                                  onTap: () {
                                    goToMap(
                                        snapshot.data[index]
                                            .pi_latit ,
                                        snapshot.data[index]
                                            .pi_longi);
                                  },
                                ),
                                Text(")", style: TextStyle(fontSize: 12.0)),
                              ]),

                              Row(children: <Widget>[
                                SizedBox(width: MediaQuery.of(context).size.width*0.02),
                                Text("Out: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)),
                                Text(snapshot.data[index].po_time
                                    .toString()+" (",style: TextStyle(fontSize: 12.0)),
                                InkWell(
                                  child: Text(
                                      snapshot.data[index]
                                          .po_loc.toString(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.0)),
                                  onTap: () {
                                    goToMap(
                                        snapshot.data[index]
                                            .pi_latit ,
                                        snapshot.data[index]
                                            .pi_longi);
                                  },
                                ),
                                Text(")", style: TextStyle(fontSize: 12.0)),
                              ]),
                              Row(children: <Widget>[
                                SizedBox(width: MediaQuery.of(context).size.width*0.02),
                                Text("Odometer Start: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)),
                                Text(snapshot.data[index].start
                                    .toString(),style: TextStyle(fontSize: 12.0)),
                                Text(" Odometer Finish: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)),
                                Text(snapshot.data[index].finish
                                    .toString(),style: TextStyle(fontSize: 12.0)),

                              ]),*/

                      snapshot.data[index].desc == ''
                          ? Container()
                          : snapshot.data[index].desc != 'Visit out not punched'
                              ? Row(
                                  children: <Widget>[
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Text(
                                      'Remark: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(snapshot.data[index].desc)
                                  ],
                                )
                              : Row(
                                  children: <Widget>[
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Text(
                                      'Remark: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    Text(
                                      snapshot.data[index].desc,
                                      style: TextStyle(color: Colors.red),
                                    )
                                  ],
                                ),
                      // SizedBox(height: 4.0,),
                      Divider(
                        color: Colors.black26,
                      ),
                    ]);
                  });
            } else if (snapshot.hasError) {
              return new Text("Unable to connect server");
            }

            // By default, show a loading spinner
            return new Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ]);
  }
}

class User {
  String AttendanceDate;
  String thours;
  String TimeOut;
  String TimeIn;
  String bhour;
  String EntryImage;
  String checkInLoc;
  String ExitImage;
  String CheckOutLoc;
  String latit_in;
  String longi_in;
  String latit_out;
  String longi_out;
  int id = 0;

  User(
      {this.AttendanceDate,
      this.thours,
      this.id,
      this.TimeOut,
      this.TimeIn,
      this.bhour,
      this.EntryImage,
      this.checkInLoc,
      this.ExitImage,
      this.CheckOutLoc,
      this.latit_in,
      this.longi_in,
      this.latit_out,
      this.longi_out});
}

String dateFormatter(String date_) {
  // String date_='2018-09-2';
  var months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  var dy = [
    'st',
    'nd',
    'rd',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'st',
    'nd',
    'rd',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'st'
  ];
  var date = date_.split("-");
  return (date[2] +
      "" +
      dy[int.parse(date[2]) - 1] +
      " " +
      months[int.parse(date[1]) - 1]);
}
