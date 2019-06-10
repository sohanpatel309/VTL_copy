// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:Shrine/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shrine/services/gethome.dart';
import 'package:Shrine/services/services.dart';
import 'employee_list.dart';
import 'home.dart';
import 'settings.dart';
import 'profile.dart';
import 'reports.dart';

class Visitdetails extends StatefulWidget {
  @override
  _Visitdetails createState() => _Visitdetails();
  Punch mv;
  //final String org_name;
  Visitdetails({this.mv});
  //print();
}

class _Visitdetails extends State<Visitdetails> {

  bool isloading = false;
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _countryCode = TextEditingController();
  final _countryId = TextEditingController();
  final _contact = TextEditingController();
  final _pass = TextEditingController();
  String admin_sts='0';
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Punch myvisit;
  int response=0;
  bool pageload=true;
  int _currentIndex = 2;
  String dept='0',desg='0',shift='0',adminsts='0';
  String org_name="";
  bool _obscureText = true;
  bool _isButtonDisabled=false;
  List<Map> countrylist=[{"id":"0#","name":"country"},{"id":"2#+93","name":"Afghanistan"},{"id":"4#+355","name":"Albania"},{"id":"50#+213","name":"Algeria"},{"id":"5#+1","name":"American Samoa"},{"id":"6#+376","name":"Andorra"},{"id":"7#+244","name":"Angola"},{"id":"11#+264","name":"Anguilla"},{"id":"3#+1","name":"Antigua and Barbuda"},{"id":"160#+54","name":"Argentina"},{"id":"8#+374","name":"Armenia"},{"id":"9#+297","name":"Aruba"},{"id":"10#+61","name":"Australia"},{"id":"1#+43","name":"Austria"},{"id":"12#+994","name":"Azerbaijan"},{"id":"27#+242","name":"Bahamas"},{"id":"25#+973","name":"Bahrain"},{"id":"14#+880","name":"Bangladesh"},{"id":"15#+246","name":"Barbados"},{"id":"29#+375","name":"Belarus"},{"id":"13#+32","name":"Belgium"},{"id":"30#+501","name":"Belize"},{"id":"16#+229","name":"Benin"},{"id":"17#+441","name":"Bermuda"},{"id":"20#+975","name":"Bhutan"},{"id":"23#+591","name":"Bolivia"},{"id":"22#+387","name":"Bosnia and Herzegovina"},{"id":"161#+267","name":"Botswana"},{"id":"24#+55","name":"Brazil"},{"id":"28#+284","name":"British Virgin Islands"},{"id":"26#+673","name":"Brunei"},{"id":"19#+359","name":"Bulgaria"},{"id":"18#+226","name":"Burkina Faso"},{"id":"21#+257","name":"Burundi"},{"id":"101#+855","name":"Cambodia"},{"id":"32#+237","name":"Cameroon"},{"id":"34#+1","name":"Canada"},{"id":"43#+238","name":"Cape Verde"},{"id":"33#+345","name":"Cayman Islands"},{"id":"163#+236","name":"Central African Republic"},{"id":"203#+235","name":"Chad"},{"id":"165#+56","name":"Chile"},{"id":"205#+86","name":"China"},{"id":"233#+61","name":"Christmas Island"},{"id":"39#+891","name":"Cocos Islands"},{"id":"38#+57","name":"Colombia"},{"id":"40#+269","name":"Comoros"},{"id":"41#+682","name":"Cook Islands"},{"id":"42#+506","name":"Costa Rica"},{"id":"36#+225","name":"Cote dIvoire"},{"id":"90#+385","name":"Croatia"},{"id":"31#+53","name":"Cuba"},{"id":"44#+357","name":"Cyprus"},{"id":"45#+420","name":"Czech Republic"},{"id":"48#+45","name":"Denmark"},{"id":"47#+253","name":"Djibouti"},{"id":"226#+767","name":"Dominica"},{"id":"49#+1","name":"Dominican Republic"},{"id":"55#+593","name":"Ecuador"},{"id":"58#+20","name":"Egypt"},{"id":"57#+503","name":"El Salvador"},{"id":"80#+240","name":"Equatorial Guinea"},{"id":"56#+291","name":"Eritrea"},{"id":"60#+372","name":"Estonia"},{"id":"59#+251","name":"Ethiopia"},{"id":"62#+500","name":"Falkland Islands"},{"id":"63#+298","name":"Faroe Islands"},{"id":"65#+679","name":"Fiji"},{"id":"186#+358","name":"Finland"},{"id":"61#+33","name":"France"},{"id":"64#+594","name":"French Guiana"},{"id":"67#+689","name":"French Polynesia"},{"id":"69#+241","name":"Gabon"},{"id":"223#+220","name":"Gambia"},{"id":"70#+970","name":"Gaza Strip"},{"id":"77#+995","name":"Georgia"},{"id":"46#+49","name":"Germany"},{"id":"78#+233","name":"Ghana"},{"id":"75#+350","name":"Gibraltar"},{"id":"81#+30","name":"Greece"},{"id":"82#+299","name":"Greenland"},{"id":"228#+473","name":"Grenada"},{"id":"83#+590","name":"Guadeloupe"},{"id":"84#+1","name":"Guam"},{"id":"76#+502","name":"Guatemala"},{"id":"72#+44","name":"Guernsey"},{"id":"167#+224","name":"Guinea"},{"id":"79#+245","name":"Guinea-Bissau"},{"id":"85#+592","name":"Guyana"},{"id":"168#+509","name":"Haiti"},{"id":"218#+379","name":"Holy See"},{"id":"87#+504","name":"Honduras"},{"id":"89#+852","name":"Hong Kong"},{"id":"86#+36","name":"Hungary"},{"id":"97#+354","name":"Iceland"},{"id":"93#+91","name":"India"},{"id":"169#+62","name":"Indonesia"},{"id":"94#+98","name":"Iran"},{"id":"96#+964","name":"Iraq"},{"id":"95#+353","name":"Ireland"},{"id":"74#+44","name":"Isle of Man"},{"id":"92#+972","name":"Israel"},{"id":"91#+39","name":"Italy"},{"id":"99#+876","name":"Jamaica"},{"id":"98#+81","name":"Japan"},{"id":"73#+44","name":"Jersey"},{"id":"100#+962","name":"Jordan"},{"id":"102#+7","name":"Kazakhstan"},{"id":"52#+254","name":"Kenya"},{"id":"104#+686","name":"Kiribati"},{"id":"106#+383","name":"Kosovo"},{"id":"107#+965","name":"Kuwait"},{"id":"103#+996","name":"Kyrgyzstan"},{"id":"109#+856","name":"Laos"},{"id":"114#+371","name":"Latvia"},{"id":"171#+961","name":"Lebanon"},{"id":"112#+266","name":"Lesotho"},{"id":"111#+231","name":"Liberia"},{"id":"110#+218","name":"Libya"},{"id":"66#+423","name":"Liechtenstein"},{"id":"113#+370","name":"Lithuania"},{"id":"108#+352","name":"Luxembourg"},{"id":"117#+853","name":"Macau"},{"id":"125#+389","name":"Macedonia"},{"id":"172#+261","name":"Madagascar"},{"id":"132#+265","name":"Malawi"},{"id":"118#+60","name":"Malaysia"},{"id":"131#+960","name":"Maldives"},{"id":"173#+223","name":"Mali"},{"id":"115#+356","name":"Malta"},{"id":"124#+692","name":"Marshall Islands"},{"id":"119#+596","name":"Martinique"},{"id":"170#+222","name":"Mauritania"},{"id":"130#+230","name":"Mauritius"},{"id":"120#+262","name":"Mayotte"},{"id":"123#+52","name":"Mexico"},{"id":"68#+691","name":"Micronesia"},{"id":"122#+373","name":"Moldova"},{"id":"121#+377","name":"Monaco"},{"id":"127#+976","name":"Mongolia"},{"id":"126#+382","name":"Montenegro"},{"id":"128#+664","name":"Montserrat"},{"id":"116#+212","name":"Morocco"},{"id":"129#+258","name":"Mozambique"},{"id":"133#+95","name":"Myanmar"},{"id":"136#+264","name":"Namibia"},{"id":"137#+674","name":"Nauru"},{"id":"139#+977","name":"Nepal"},{"id":"142#+31","name":"Netherlands"},{"id":"135#+599","name":"Netherlands Antilles"},{"id":"138#+687","name":"New Caledonia"},{"id":"146#+64","name":"New Zealand"},{"id":"140#+505","name":"Nicaragua"},{"id":"174#+227","name":"Niger"},{"id":"225#+234","name":"Nigeria"},{"id":"141#+683","name":"Niue"},{"id":"145#+672","name":"Norfolk Island"},{"id":"144#+850","name":"North Korea"},{"id":"143#+1","name":"Northern Mariana Islands"},{"id":"134#+47","name":"Norway"},{"id":"147#+968","name":"Oman"},{"id":"153#+92","name":"Pakistan"},{"id":"150#+680","name":"Palau"},{"id":"149#+507","name":"Panama"},{"id":"155#+675","name":"Papua New Guinea"},{"id":"157#+595","name":"Paraguay"},{"id":"151#+51","name":"Peru"},{"id":"178#+63","name":"Philippines"},{"id":"152#+64","name":"Pitcairn Islands"},{"id":"154#+48","name":"Poland"},{"id":"148#+351","name":"Portugal"},{"id":"156#+1","name":"Puerto Rico"},{"id":"158#+974","name":"Qatar"},{"id":"164#+243","name":"Republic of the Congo"},{"id":"166#+262","name":"Reunion"},{"id":"175#+40","name":"Romania"},{"id":"159#+7","name":"Russia"},{"id":"182#+250","name":"Rwanda"},{"id":"88#+290","name":"Saint Helena"},{"id":"105#+869","name":"Saint Kitts and Nevis"},{"id":"229#+758","name":"Saint Lucia"},{"id":"191#+1","name":"Saint Martin"},{"id":"195#+508","name":"Saint Pierre and Miquelon"},{"id":"232#+784","name":"Saint Vincent and the Grenadines"},{"id":"230#+685","name":"Samoa"},{"id":"180#+378","name":"San Marino"},{"id":"197#+239","name":"Sao Tome and Principe"},{"id":"184#+966","name":"Saudi Arabia"},{"id":"193#+221","name":"Senegal"},{"id":"196#+381","name":"Serbia"},{"id":"200#+248","name":"Seychelles"},{"id":"224#+232","name":"Sierra Leone"},{"id":"187#+65","name":"Singapore"},{"id":"188#+421","name":"Slovakia"},{"id":"190#+386","name":"Slovenia"},{"id":"189#+677","name":"Solomon Islands"},{"id":"194#+252","name":"Somalia"},{"id":"179#+27","name":"South Africa"},{"id":"176#+82","name":"South Korea"},{"id":"51#+34","name":"Spain"},{"id":"37#+94","name":"Sri Lanka"},{"id":"198#+249","name":"Sudan"},{"id":"192#+597","name":"Suriname"},{"id":"199#+47","name":"Svalbard"},{"id":"185#+268","name":"Swaziland"},{"id":"183#+46","name":"Sweden"},{"id":"35#+41","name":"Switzerland"},{"id":"201#+963","name":"Syria"},{"id":"162#+886","name":"Taiwan"},{"id":"202#+992","name":"Tajikistan"},{"id":"53#+255","name":"Tanzania"},{"id":"204#+66","name":"Thailand"},{"id":"206#+670","name":"Timor-Leste"},{"id":"181#+228","name":"Togo"},{"id":"209#+676","name":"Tonga"},{"id":"211#+868","name":"Trinidad and Tobago"},{"id":"208#+216","name":"Tunisia"},{"id":"210#+90","name":"Turkey"},{"id":"207#+993","name":"Turkmenistan"},{"id":"212#+1","name":"Turks and Caicos Islands"},{"id":"213#+688","name":"Tuvalu"},{"id":"219#+1","name":"U.S. Virgin Islands"},{"id":"54#+256","name":"Uganda"},{"id":"214#+380","name":"Ukraine"},{"id":"215#+971","name":"United Arab Emirates"},{"id":"71#+44","name":"United Kingdom"},{"id":"216#+1","name":"United States"},{"id":"177#+598","name":"Uruguay"},{"id":"217#+998","name":"Uzbekistan"},{"id":"221#+678","name":"Vanuatu"},{"id":"235#+58","name":"Venezuela"},{"id":"220#+84","name":"Vietnam"},{"id":"222#+681","name":"Wallis and Futuna"},{"id":"227#+970","name":"West Bank"},{"id":"231#+212","name":"Western Sahara"},{"id":"234#+967","name":"Yemen"},{"id":"237#+243","name":"Zaire"},{"id":"236#+260","name":"Zambia"},{"id":"238#+263","name":"Zimbabwe"}];

  String country = "0#";
  List<Map> shiftList;
  // List<Map> statusList= [{"id":"1","name":"Admin"},{"id":"0","name":"User"}];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    //  shiftList= getShifts();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    response = prefs.getInt('response') ?? 0;
    if(response==1) {
      Home ho = new Home();
      setState(() {
        org_name = prefs.getString('org_name') ?? '';
        admin_sts = prefs.getString('sstatus') ?? '0';

        myvisit=widget.mv;
        print(myvisit.client);
      });
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget(){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(org_name, style: new TextStyle(fontSize: 20.0)),
          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
          Navigator.pop(context);
          /*  Navigator.push(
            context,
           MaterialPageRoute(builder: (context) => TimeoffSummary()),
          );*/
        },),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }else if (newIndex == 0) {
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
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            return;
          }
          setState((){_currentIndex = newIndex;});

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
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,color: Colors.black54,),
              title: Text('Settings',style: TextStyle(color: Colors.black54),)
          )
        ],
      ),
      endDrawer: new AppDrawer(),
      body:  checkalreadylogin(),
    );
  }

  checkalreadylogin(){
    if(response==1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          underdevelopment(),
          mainbodyWidget(),
        ],
      );
    }else{
      /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );*/
    }
  }

  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 30.0, width: 30.0),
            ]),
      ),
    );
  }

  underdevelopment(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android,color: Colors.teal,),Text("Under development",style: new TextStyle(fontSize: 30.0,color: Colors.teal),)
            ]),
      ),
    );
  }

  mainbodyWidget(){
    if(pageload==true)
      loader();

    return Center(
      child: Form(
        key: _formKey,
        child: SafeArea(
            child: Column( children: <Widget>[
              SizedBox(height: 20.0),
              Text('Visit Details',
                  style: new TextStyle(fontSize: 22.0, color: Colors.orangeAccent)),
              new Divider(color: Colors.black54,height: 1.5,),
              SizedBox(height: 20.0),

              new Expanded(
                // padding: EdgeInsets.only(left:10.0,right:10.0),
                //    margin: EdgeInsets.only(top:25.0),
                child: ListView(
                  children: <Widget>[

                    Container(
                        padding: new EdgeInsets.only(left: 15.0, right: 10.0),
                        decoration: new ShapeDecoration(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                            color: Colors.white.withOpacity(0.1)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Row(
                            children: <Widget>[
                              //SizedBox(width: MediaQuery.of(context).size.width*0.02),
                             // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Client: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text(myvisit.client, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.01),

                          Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Time In: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text(myvisit.pi_time, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height*.01),
                          Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Location In: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),

                                InkWell(
                                  child: Text(
                                      myvisit
                                          .pi_loc.toString(),
                                      maxLines: 2,
                                      style: TextStyle(
                                          //color: Colors.black54,
                                          fontSize: 12.0)),
                                  onTap: () {
                                    goToMap(
                                        myvisit
                                            .pi_latit ,
                                        myvisit
                                            .pi_longi);
                                  },
                                ),

                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.01),
                          Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Time Out: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text(myvisit.po_time, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.01),
                          Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Location Out: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              Flexible(
                                child: InkWell(
                                  child: Text(
                                      myvisit
                                          .po_loc.toString(),
                                      style: TextStyle(
                                         // color: Colors.black54,
                                          fontSize: 12.0)),
                                  onTap: () {
                                    goToMap(
                                        myvisit
                                            .po_latit ,
                                        myvisit
                                            .po_longi);
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height*.01),
                          Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Action: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text(myvisit.action, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height*.01),
                          Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Pro#: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text(myvisit.pro, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height*.01),
                          Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Trailer#: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text(myvisit.trailer, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.01),
                          Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Remark In: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text(myvisit.remarkin, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.01),
                          Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Remark Out: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text(myvisit.desc, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.02),
                          /*Text('Odometer',style: TextStyle(fontWeight: FontWeight.bold,fontSize:16.0),textAlign: TextAlign.left),
                          new Divider(color: Colors.black54,height: 1.5,),
                          SizedBox(height: 20.0),
                          //SizedBox(height: MediaQuery.of(context).size.height*.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                             // new Text("Start: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text("Start: "+myvisit.start, style: new TextStyle(fontSize: 15.0)),
                            //  new Text("Finish: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text("Finish: "+myvisit.finish, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),*/

                          SizedBox(height: MediaQuery.of(context).size.height*.01),
                         /* Row(
                            children: <Widget>[
                              // Icon(Icons.perm_identity,size: 20.0,color: Colors.black54,),SizedBox(width: 5.0),
                              new Text("Finish: ", style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                              new Text(myvisit.finish, style: new TextStyle(fontSize: 15.0)),
                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height*.01),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //---------------------------------------------------

              //---------------------------------------------------
            ]
            )
        ),
      ),
    );
  }
  ////////////////common dropdowns

}