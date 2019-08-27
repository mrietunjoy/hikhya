import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_linux_first/main_screen.dart';
import 'package:splashscreen/splashscreen.dart';
import 'engchapters.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_linux_first/dbhelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class charts_file extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return charts_file_state();
  }

}

SharedPreferences sp;
int epoints=0;
int mpoints=0;
int spoints=0;
FirebaseAuth auth=FirebaseAuth.instance;
GoogleSignIn gsi = new GoogleSignIn();

class charts_file_state extends State<charts_file>{
  Future<FirebaseUser> signin() async{
    GoogleSignInAccount gsia = await gsi.signIn();
    GoogleSignInAuthentication gsauth = await gsia.authentication;

    FirebaseUser appuser = await auth.signInWithGoogle(idToken: gsauth.idToken, accessToken: gsauth.accessToken);

    print("User name: ${appuser.displayName}");
    return appuser;
  }

  void sign_out(){
    gsi.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            height: 250,
          ),
            RaisedButton(
              color: Color(0xff4285F4),
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
              child: Text("Sign In", style: TextStyle(color: Color(0xffffffff), fontSize: 18)),
              onPressed: () async {
                _setpoints();
                FirebaseUser auser = await signin();

                if(auser.displayName!=null)
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>getcf()));

            },
            ),
            RaisedButton(
              color: Color(0xffed2939),
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
              child: Text("Sign Out", style: TextStyle(color: Color(0xffffffff), fontSize: 18),),
              onPressed: () {
                sign_out();
            },
            ),
        ],
      ),
    );
  }

}

Widget chart_dis(int epoints, int mpoints, int spoints){
  _setpoints();
  var piechart=[
    datacharts('English', epoints, Color(0xffff0000)),
    datacharts('Maths', mpoints, Color(0xff00ff00)),
    datacharts('Science', spoints, Color(0xff0000ff)),
  ];

  var series=[
    charts.Series(
        domainFn: (datacharts dc, _)=>dc.subject,
        id: 'Points',
        data:piechart,
        measureFn: (datacharts dc, _)=>dc.points,
        colorFn: (datacharts dc, _)=>charts.ColorUtil.fromDartColor(dc.color_of_graph),

    )
  ];

  var chart = new charts.BarChart(
    series,
    animate: true,
  );


  return Column(
    children: <Widget>[
      Container(
          width: 200,
          height: 200,
          child: chart),

    ],
  );
}
var stackdes=[];
class datacharts{
  String subject;
  int points;
  Color color_of_graph;

  datacharts(this.subject, this.points, this.color_of_graph);
}

class inc_points extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return inc_point_s();
  }

}

class inc_point_s extends State<inc_points>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}

class Fquiz extends StatefulWidget{
  Fquiz({this.subject});
  String subject;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Fquizstate();
  }
  
}

var question=[];
var rans=[];
var o1=[];
var o2=[];
var o3=[];


class Fquizstate extends State<Fquiz>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: StreamBuilder(
          stream: setstream(widget.subject),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(body: Text('Wait'));
            }else if(snapshot.hasError || snapshot.data.documents == null){
              return Scaffold(body: Text('Error'));
            }
            else {
              clearquestion();
              print(quizques);
              _setpoints;
              for(int i=0; i<snapshot.data.documents.length; i++){
                additems(snapshot.data.documents[i], widget.subject);
                //snapshot.data.documents[i]=null;
              }
              return setquiz(subject: widget.subject,);
            };
          }
      ),
    );
  }
  
}

//set the stream of diffrent question
Stream<QuerySnapshot> setstream(String subject){
  if(subject=="english") {
    return Firestore.instance.collection('quiz').snapshots();
  }else if(subject == "maths"){
    return Firestore.instance.collection('mquiz').snapshots();
  }
}

_setpoints() async{
  sp=await SharedPreferences.getInstance();
  epoints=sp.getInt("epoints");
  print("epoints: ${epoints}");
  if(epoints==null){
    epoints=0;
    sp.setInt("epoints", 0);
  }
  mpoints=sp.getInt("mpoints");
  print("mpoints: ${mpoints}");
  if(mpoints==null){
    mpoints=0;
    sp.setInt("mpoints", 0);
  }
  spoints=sp.getInt("spoints");
  print("spoints: ${spoints}");
  if(spoints==null){
    spoints=0;
    sp.setInt("spoints", 0);
  }
}


void additems(DocumentSnapshot doc, String subject){

    question.add(doc['question']);
    o1.add(doc['o1']);
    o2.add(doc['o2']);
    o3.add(doc['o3']);
    rans.add(doc['rans']);
  print("add question: ${question.length}");
}

void clearquestion(){
  question.clear();
  o1.clear();
  o2.clear();
  o3.clear();
  rans.clear();
  print("clear question: ${question.length}");
}

class setquiz extends StatefulWidget{
  setquiz({this.subject});
  String subject;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return setQuizState();
  }

}

int quizques=0;

class setQuizState extends State<setquiz>{
  static Random i=new Random();
  int sel = i.nextInt(question.length);
  Future<bool> _backpressed() async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>getcf()));
    return await true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("i: $sel");
    if(quizques==5){
      clearquestion();
      quizques=0;
      return getcf();
    }else
    return WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(
          appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back_ios),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>getcf()));
                  }
              )
          ),
        body:  Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Text(question[sel], softWrap: true, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Color(0xffffcc00)),),
              ),
            ),
            Container(
                child: Column(
                  children: <Widget>[
                    FlatButton(onPressed: (){
                      print(quizques);
                      if(rans[sel] == o1[sel]){
                        //do something
                        if(widget.subject == "english") {
                          epoints += 1;
                          quizques++;
                          sp.setInt("epoints", epoints);
                        } else if(widget.subject == "maths") {
                          quizques++;
                          mpoints += 1;
                          sp.setInt("mpoints", mpoints);
                        }else if(widget.subject == "science") {
                          quizques++;
                          spoints += 1;
                          sp.setInt("spoints", spoints);
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>setquiz(subject: widget.subject,)));
                      }else if(quizques==5) {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>getcf()));
                      }  else
                      {
                        quizques++;
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>setquiz(subject: widget.subject,)));
                      }
                    }, child: Container(
                      color: Color(0x30ffffff),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(o1[sel], style: TextStyle(color: Color(0x500000ff), fontSize: 20),),
                          ),
                        ],
                      ),
                    ),
                    ),
                    FlatButton(onPressed: (){
                      if(rans[sel] == o2[sel]){
                        //do something
                        if(widget.subject == "english") {
                          epoints += 1;
                          quizques++;
                          sp.setInt("epoints", epoints);
                        } else if(widget.subject == "maths") {
                          mpoints += 1;
                          quizques++;
                          sp.setInt("mpoints", mpoints);
                        }else if(widget.subject == "science") {
                          spoints += 1;
                          quizques++;
                          sp.setInt("spoints", spoints);
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>setquiz(subject: widget.subject,)));
                      }else if(quizques==5) {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>getcf()));
                      }
                      else{
                        quizques++;
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>setquiz(subject: widget.subject,)));
                      }
                    }, child: Container(
                      color: Color(0x30ffffff),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(o2[sel], style: TextStyle(color: Color(0x500000ff), fontSize: 20)),
                          ),
                        ],
                      ),
                    ),),
                    FlatButton(onPressed: (){
                      if(rans[sel] == o3[sel]){
                        //do something
                        if(widget.subject == "english") {
                          epoints += 1;
                          quizques++;
                          sp.setInt("epoints", epoints);
                        } else if(widget.subject == "maths") {
                          mpoints += 1;
                          quizques++;
                          sp.setInt("mpoints", mpoints);
                        }else if(widget.subject == "science") {
                          spoints += 1;
                          quizques++;
                          sp.setInt("spoints", spoints);
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>setquiz(subject: widget.subject,)));
                      }else if(quizques==5) {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>getcf()));
                      }else{
                        quizques++;
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>setquiz(subject: widget.subject,)));
                      }
                    }, child: Container(
                      color: Color(0x30ffffff),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(o3[sel], style: TextStyle(color: Color(0x500000ff), fontSize: 20)),
                          ),
                        ],
                      ),
                    ),),
                  ],
                )
            )
          ],
        )
      ),
    );
  }

}
String x="";
class checkdis extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return check_db();
  }

}


class check_db extends State<checkdis>{
  final dbh = engdbhelper.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getengch();
  }

  @override
  void initState() {

  }

}


void _insert(engdbhelper edb, Map<String, dynamic> row) async {
  // row to insert
  final id = await edb.insert(row);
  print('inserted row id: $id');
}


void _query(engdbhelper edb) async {
  final allRows = await edb.queryAllRows();
  print('query all rows:');
  allRows.forEach((row) => print(row));
}
var stack=[];
var allRows;
_querychaptername(engdbhelper edb) async {
  allRows = await edb.queryChapterNameRows();
  for(int i=0; i<allRows.length && stack.length<allRows.length; i++) {
    EngDB engDB=await EngDB.fromjson(allRows[i]);
    stack.add(engDB.chaptername);
    print("inserting ${engDB.chaptername}");
  }
  return "";
//  print(engDB.chaptername);
}

class EngDB{
  String explanation;
  String chaptername;
  String des;

  EngDB({
    this.chaptername,
    this.explanation,
    this.des
});

  factory EngDB.fromjson(Map<String, dynamic> json) => new EngDB(
      explanation: json["explanation"],
    chaptername: json["chapter_name"],
    des: json["description"]
  );
}

class MathDB{
  String explanation;
  String chaptername;
  String des;

  MathDB({
    this.chaptername,
    this.explanation,
    this.des
  });

  factory MathDB.fromjson(Map<String, dynamic> json) => new MathDB(
      explanation: json["explanation"],
      chaptername: json["chapter_name"],
      des: json["description"]
  );
}

class show extends StatelessWidget{
  var y;
  show({
    this.y,
});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: y.length,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(y[index]),
          );
        }
    );
  }

}

class getengch extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return getchstate();
  }

}

class getchstate extends State<getengch>{
  var chno=[], chname=[], des=[], schname=[];
  final edb=engdbhelper.instance;
  int i=1,k;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            child: StreamBuilder(
                stream: Firestore.instance.collection('englishchapters').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return Text('Hello');
                  }else{
                    for(int i=0; i<snapshot.data.documents.length; i++){
                      add_engch(snapshot.data.documents[i]);
                    }
                    edb.delete();
                    for(int i=0;i<chno.length;i++){
                      Map<String, dynamic> row=createRow(chno[i], chname[i], des[i]);
                      _insert(edb, row);
                    }
//                    stack.clear();
                    print("row $stack");
                    if(stack.length>0)
                      return rc(chname);
                    else
                      _querychaptername(edb);
                      return rc(chname);
                  }
                }
            ),
          )
        ],
      ),
    );
  }

  void add_engch(DocumentSnapshot doc){
    chno.add(doc['chapterno']);
    chname.add(doc['chaptername']);
    des.add(doc['description']);
  }

  Map<String, dynamic> createRow(String chno, String chname, String des){
    Map<String, dynamic> row={
      engdbhelper.explanation: chno,
      engdbhelper.chapter_name: chname,
      engdbhelper.description: des,
    };
    return row;
  }

}



Widget rc(List chname) {

  final edb=engdbhelper.instance;
  _querychaptername(edb);
  print("Stack $stack");
  if(chname.length>0) {
    return
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: new ListView.builder(
              itemCount: chname.length,
              itemBuilder: (BuildContext ctxt, int index){
                return RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30))
                  ),
                    child: new Text(chname[index]), onPressed: () {

                },
                );
              },
            ),
          ),
        );
  }
  else{
    return Center(child: Text("Loading"));
  }
}

Widget getdes(String stackde){
  return Scaffold(
    body: Center(child: Text(stackde)),
  );
}

String chget(Map<String, dynamic> k, int i){
  EngDB engDB=EngDB.fromjson(k[i]);
  String x=engDB.chaptername;
  return x;
}
class getcf extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return getchartfile();
  }

}

class getchartfile extends State<getcf>{

  Future<bool> _backpressed() async{
    getpage(2);
    return await true;
  }

  getcharts(){
    if(epoints!=null&&mpoints!=null&&spoints!=null){

      return chart_dis(epoints, mpoints, spoints);
    }else{
      return Text('Loading');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                  page_id=2;
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>main_screen()));
                  //call the navigitor and Scaffold getpage(2);
                }
            )
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Center(
                child: getcharts()
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    color: Color(0xfffc766a),
                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                    onPressed: (){
                      clearquestion();
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>getengch()));
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Fquiz(subject: "english",)));
                    },
                    child: Center(
                      child: Text('English'),
                    ),
                  ),
                ),
                RaisedButton(
                  color: Color(0xff5b84b1),
                  padding: const EdgeInsets.all(10.0),
                  shape: BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                  onPressed: (){
                    //to be changed
                    clearquestion();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Fquiz(subject: "maths",)));
                  },
                  child: Center(
                    child: Text('Maths'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}

