import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:Shrine/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:Shrine/addShift.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'home.dart';
import 'settings.dart';
import 'profile.dart';
import 'reports.dart';
import 'visitdetails.dart';

class VisitList extends StatefulWidget {
  @override
  _VisitList createState() => _VisitList();
}

TextEditingController today;

//FocusNode f_dept ;
class _VisitList extends State<VisitList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  String admin_sts='0';
  bool res = true;
  var formatter = new DateFormat('dd-MMM-yyyy');

  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    // f_dept = FocusNode();
    getOrgName();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName = prefs.getString('org_name') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '0';
    });
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  getmainhomewidget() {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(_orgName, style: new TextStyle(fontSize: 20.0)),

            /*  Image.asset(
                    'assets/logo.png', height: 40.0, width: 40.0),*/
          ],
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            return;
          }if (newIndex == 0) {
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
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }
          setState((){_currentIndex = newIndex;});

        },// this will be set when a new tab is tapped
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
            title: new Text('Home',style: TextStyle(color: Colors.black54),),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings'))
        ],
      ),
      endDrawer: new AppDrawer(),
      body: Container(
        //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Visits',
                style: new TextStyle(
                  fontSize: 22.0,
                  color: Colors.black54,
                ),
              ),
            ),
            Divider(
              height: 10.0,
            ),
            SizedBox(height: 2.0),
            Container(
              child: DateTimePickerFormField(
                dateOnly: true,
                format: formatter,
                controller: today,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.date_range,
                      color: Colors.grey,
                    ), // icon is 48px widget.
                  ), // icon is 48px widget.
                  labelText: 'Select Date',
                ),
                onChanged: (date) {
                  setState(() {
                    if (date != null && date.toString() != '')
                      res = true; //showInSnackBar(date.toString());
                    else
                      res = false;
                  });
                },
                validator: (date) {
                  if (date == null) {
                    return 'Please select date';
                  }
                },
              ),
            ),
            SizedBox(height: 12.0),
            Container(
              //  padding: EdgeInsets.only(bottom:10.0,top: 10.0),
       //       width: MediaQuery.of(context).size.width * .9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 1.0,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text(
                      'Name',
                      style: TextStyle(color: Colors.orange),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Text(
                      'Client',
                      style: TextStyle(color: Colors.orange),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Text('In',
                        style: TextStyle(color: Colors.orange),
                        textAlign: TextAlign.left),
                  ),Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Text('Out',
                        style: TextStyle(color: Colors.orange),
                        textAlign: TextAlign.left),
                  ),
                  /*Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text('Out ',
                        style: TextStyle(color: Colors.orange),
                        textAlign: TextAlign.left),
                  ),*/
                ],
              ),
            ),
            SizedBox(height: 5.0),
            Divider(
              height: 5.2,
            ),
            new Expanded(
              child: res == true ? getEmpDataList(today.text) : Center(),
            ),
          ],
        ),
      ),
    );
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

  getEmpDataList(date) {
    return new FutureBuilder<List<Punch>>(
        future: getVisitsDataList(date),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
            //          width: MediaQuery.of(context).size.width * .9,
                        child:Column(children: <Widget>[
                      new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: 8.0,),
                            new Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                        snapshot.data[index].Emp.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                    /*new Text("In: "+snapshot.data[index].pi_time
                                        .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    new Text("Out: "+snapshot.data[index].po_time
                                        .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),*/
                                  ],
                                )),
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    snapshot.data[index].client.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: new Container(
                                        //width: MediaQuery.of(context).size.width*0.30,
                                        height: 25.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.orangeAccent,
                                          border: new Border.all(color: Colors.white, width: 2.0),
                                          borderRadius: new BorderRadius.circular(10.0),
                                        ),
                                        child: new Center(child: new Text('View Details', style: new TextStyle(fontSize: 12.0, color: Colors.white),),),
                                      ),
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Visitdetails(mv: snapshot.data[index])),
                                        );
                                      },),
                                  )
                                ],
                              ),

                            ),
                            Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: <Widget>[
                                    new Text(
                                      snapshot.data[index].pi_time.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                                    ),
                                    InkWell(
                                      child:Text("In: "+
                                          snapshot.data[index].pi_loc.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                      onTap: () {goToMap(snapshot.data[index].pi_latit,snapshot.data[index].pi_longi.toString());},
                                    ),

                                   /* Row(children: <Widget>[
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
                                   /* Row(children: <Widget>[
                                      Text("Trailer#: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(snapshot.data[index].trailer
                                          .toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    ]),*/
                                    /*Container(
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
                                )

                            ),
                            Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: <Widget>[
                                    Text(snapshot.data[index].po_time
                                        .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                    InkWell(
                                      child:Text("Out: "+
                                          snapshot.data[index].po_loc.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                      onTap: () {goToMap(snapshot.data[index].po_latit.toString(),snapshot.data[index].po_longi.toString());},
                                    ),
                                    /*Container(
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
                                          )),),*/

                                  ],
                                )

                            ),
                          ],
                        ),
                      SizedBox(height: 10.0,),
                      Divider(
                        color: Colors.blueGrey.withOpacity(0.25),
                        height: 0.2,
                      ),
                      SizedBox(height: 10.0,),
                    ]),
                    );
                  });
            } else {
              return new Center(
                child: Text("No Visits ", style: TextStyle(color: Colors.orangeAccent,fontSize: 18.0),),
              );
            }
          } else if (snapshot.hasError) {
		   return new Text("Unable to connect server");
          }
          // return loader();
          return new Center(child: CircularProgressIndicator());
        });
  }
} /////////mail class close
