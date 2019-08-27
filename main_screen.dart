import 'dart:io';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linux_first/chapters.dart';
import 'package:flutter_linux_first/charts_file.dart';
import 'package:flutter_linux_first/jwords.dart';
import 'package:flutter_linux_first/dbhelper.dart';

class main_screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return main_screen_display();
  }
}

AnimationController animationController;
int bcolor=0xffffde04;
class main_screen_display extends State<main_screen> with TickerProviderStateMixin{

  var bottom_select = 0;
  bool is_select = true;
  AnimationController ac;
  Animation animationc;
  var platfrom = MethodChannel("com.mrietunjoy.flutter_linux_first");
  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 7),
    );
    ac = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    animationc= Tween(begin: 1, end: 0).animate(CurvedAnimation(parent: ac, curve: Curves.fastOutSlowIn));

    ac.forward();
    animationController.repeat();
  }

  final engdb=engdbhelper.instance;
  var explain=[], echname=[], edes=[];
  int k=1;

  Future<bool> _backpressed() async{
    exit(0);
    return await true;
  }

  @override
  Widget build(BuildContext context) {
    echname.clear();
    explain.clear();
    edes.clear();
    explain=explanation;
    edes=eng_chdes;
    echname=engchapter_name;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _backpressed,
      child: Scaffold(
        backgroundColor: new Color(bcolor),
        body: StreamBuilder(
            stream: Firestore.instance.collection('englishchapters').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                bottom_select=2;
                return getpage(page_id);
              }else{
                for(int i=0; i<snapshot.data.documents.length; i++){
                  add_engch(snapshot.data.documents[i]);
                }
                engdb.delete();
                if(k==1){
                  for(int i=0;i<echname.length;i++){
                    Map<String, dynamic> row=createRow(explain[i], echname[i], edes[i]);
                    _insert(engdb, row);
                  }
                  k++;
                }
//                    stack.clear();
                _querychaptername(engdb);
                _querychapterexp(engdb);
                _querychapterdes(engdb);
                return getpage(page_id);
                print("row $stack");

              }
            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await platfrom.invokeMethod("aractivity");
            } on PlatformException catch (e) {
              print(e.message);
            }
          },
          child: Text('AR', style: TextStyle(color: Color(0xffffffff)),),
          highlightElevation: 20,
          elevation: 10,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
              canvasColor: new Color(0xff0336ff),
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: new Color(0xffff0266),
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.white70))), // sets the inactive color of the `BottomNavigationBar`
          child: new BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: bottom_select,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.book), title: Text('Main')),
              BottomNavigationBarItem(icon: Image(image: AssetImage('icons/formula.png'), color: Colors.white70,width: 24, height: 24,), title: Text('Formula Deck')),
              //BottomNavigationBarItem(icon: Icon(Icons.games), title: Text('Fun')),
              BottomNavigationBarItem(icon: Icon(Icons.games), title: Text('Fun')),
              BottomNavigationBarItem( title: Text(''), icon: Icon(Icons.arrow_left),)
            ],
            onTap: (isset){
              setState(() {
                bottom_select=isset;
                if(bottom_select==0){
                  final engdb=engdbhelper.instance;
                  _querychaptername(engdb);
                  setState(() {
                    bcolor=0xffffde04;
                    page_id=0;
                  });
//                Navigator.push(context, MaterialPageRoute(builder: (context)=>elective_selection()));
                }else if(bottom_select==2){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>jwords()));
                  setState(() {
                    bcolor=0xffe63c8e;
                    page_id=bottom_select;
                  });
                }else if(bottom_select==1){
                  //formula deck
                  page_id=bottom_select;
                }
              });
            },
          ),
        ),
      ),
    );

  }

  @override
  void dispose() {
    super.dispose();
  }
  void add_engch(DocumentSnapshot doc){
    explain.add(doc['explanation']);
    echname.add(doc['chaptername']);
    edes.add(doc['description']);
  }

  Map<String, dynamic> createRow(String exp, String chname, String des){
    Map<String, dynamic> row={
      engdbhelper.explanation: exp,
      engdbhelper.chapter_name: chname,
      engdbhelper.description: des,
    };
    return row;
  }
}
int page_id=0;
Column getpage(int pid){
  if(pid==0) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: main_state(),
        ),
      ],
    );
  } else if(pid == 1){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: formuladeck()),
        //Center(child: Container(child: Text('Formula Deck'))),
      ],
    );
  }else if(pid == 2){
    return Column(
      children: <Widget>[
        charts_file(),
      ],
    );
  }
}

class page_follow extends StatefulWidget{

  page_follow({this.subject_ch});
  String subject_ch;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return page_follow_state();
  }

}

class page_follow_state extends State<page_follow>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(widget.subject_ch=="jwords"){
      setState(() {
        page_id=1;
      });
    }
  }

}



class main_state extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return main_state_follow();
  }
}

class main_state_follow extends State<main_state>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  new AnimatedBuilder(
                    animation: animationController,
                    child: new Container(
                      height: 80.0,
                      width: 80.0,
                      child: new Image.asset('icons/star.png'),
                    ),
                    builder: (BuildContext context, Widget _widget) {
                      return new Transform.rotate(
                        angle: animationController.value * 6.3,
                        child: _widget,
                      );
                    },
                  ),
                  Container(
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('Select subject', style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('to study', style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 330,
                      height: 80,
                      child: RaisedButton(
                        elevation: 8,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>chapters(sub: "English", chlist: engchapter_name, chdes: eng_chdes, chexp: explanation,)));
                        },
                        color: Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30))
                        ),
                        padding: EdgeInsets.only(left: 0),
                        child: Row(
                          children: <Widget>[
                            Image(image: AssetImage('icons/english_ico.png'),
                              color: Color(0xff0336ff),),
                            Text('English', style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 80,
                      child: RaisedButton(
                        elevation: 8,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>chapters(sub: "Maths",)));
                        },
                        color: Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30))
                        ),
                        child: Row(
                          children: <Widget>[
                            Image(image: AssetImage('icons/maths_ico.png'),
                              color: Color(0xffff0266),),
                            Text('Maths', style: TextStyle(fontFamily: 'Rubik',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 80,
                      child: RaisedButton(
                        elevation: 8,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>chapters(sub: "Science",)));
                        },
                        color: Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30))
                        ),
                        child: Row(
                          children: <Widget>[
                            Image(image: AssetImage('icons/science_ico.png'),
                              color: Color(0xff0336ff),),
                            Text('Science', style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 80,
                      child: RaisedButton(
                        elevation: 8,
                        onPressed: () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>charts_file()));

                        },
                        color: Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30))
                        ),
                        child: Row(
                          children: <Widget>[
                            Image(image: AssetImage('icons/social_ico.png'),
                                color: Color(0xffff0266)),
                            Text('Social Science', style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

}
var engchapter_name=[], eng_chdes=[], explanation=[];
_querychaptername(engdbhelper edb) async {
  allRows = await edb.queryChapterNameRows();
  for(int i=0; i<allRows.length && stack.length<allRows.length; i++) {
    EngDB engDB=await EngDB.fromjson(allRows[i]);
    engchapter_name.add(engDB.chaptername);
    print("inserting ${engDB.chaptername}");
  }
  return "";
//  print(engDB.chaptername);
}

_querychapterexp(engdbhelper edb) async {
  allRows = await edb.queryChapterexplanation();
  for(int i=0; i<allRows.length && stack.length<allRows.length; i++) {
    EngDB engDB=await EngDB.fromjson(allRows[i]);
    explanation.add(engDB.explanation);
    print("inserting ${engDB.explanation}");
  }
  return "";
//  print(engDB.chaptername);
}

_querychapterdes(engdbhelper edb) async {
  allRows = await edb.queryChapterdescription();
  for(int i=0; i<allRows.length && stack.length<allRows.length; i++) {
    EngDB engDB=await EngDB.fromjson(allRows[i]);
    eng_chdes.add(engDB.des);
    print("inserting ${engDB.des}");
  }
  return "";
//  print(engDB.chaptername);
}

void _insert(engdbhelper edb, Map<String, dynamic> row) async {
  // row to insert
  final id = await edb.insert(row);
  print('inserted row id: $id');
}


Widget formuladeck(){

  var platfrom = MethodChannel("com.mrietunjoy.flutter_linux_first");
  return Column(
    children: <Widget>[
      RaisedButton(
        color: Color(0xff0336ff),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Formulas', style: TextStyle(fontSize: 20, color: Color(0xffffffff)),),
        ),
        onPressed: () async {
          try{
            await platfrom.invokeMethod("showformulas");
          }on PlatformException catch (e) {
            print(e.message);
          }
        },
      )
    ],
  );
}