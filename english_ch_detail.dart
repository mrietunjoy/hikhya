import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_linux_first/main_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';

class english_ch_detail extends StatefulWidget{
  english_ch_detail({this.title, this.des, this.explain, this.qus, this.ops, this.ran, this.iqa});
  String title;
  String des;
  String explain;
  var qus=[];
  var ops=[];
  var ran=[];
  var iqa=[];
  //List ques;
  //List ans;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return english_ch_det_state();
  }
}
void _add_quiz(var question, var option, var right_answer){
  ques=question;
  ans=option;
  rans=right_answer;
}

var iqae=[];
class english_ch_det_state extends State<english_ch_detail>{
  String tts_bu="Speak";
  int bu_click=0;

  Future<bool> _backpressed(){
    page_id=0;
    Navigator.push(context, MaterialPageRoute(builder: (context)=>main_screen()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _add_quiz(widget.qus, widget.ops, widget.ran);
    iqae=widget.iqa;
    title=widget.title;
    description=widget.des;
    explanation=widget.explain;
    return WillPopScope(
      onWillPop: _backpressed,
      child: Scaffold(
          backgroundColor: Color(0xffff6600),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xffffffff)), textAlign: TextAlign.center, softWrap: true,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                      color: Color(0xffffde03),
                    ),
                    child: Center(
                      child: ExpansionTile(
                        backgroundColor: Color(0xffffffff),
                      title: Text("Chapter", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,), textAlign: TextAlign.center, softWrap: true,),
                        children: <Widget>[
                          description_section(widget.des),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                                child: RaisedButton(
                                  color: Color(0xffff0266),
                                  onPressed: () {setState(() {
                                    if(bu_click == 0)
                                    {
                                      tts_bu = "Stop";
                                      bu_click++;
                                      var lst = widget.des.split("\n\n\n");
                                      for(int i=0; i<lst.length; i++) {
                                        int result = speak(lst[i]);
                                      }
                                    }else{
                                      tts_bu="Speak";
                                      bu_click--;
                                      stop();
                                    }
                                  });
                                  },
                                  child: Text(tts_bu),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
                      color: Color(0xff006699),
                    ),
                    child: Center(
                      child: ExpansionTile(
                        backgroundColor: Color(0xffffffff),
                        title: Text("Explanation", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,), textAlign: TextAlign.center, softWrap: true,),
                        children: <Widget>[
                          description_section(widget.explain),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                                child: RaisedButton(
                                  color: Color(0xffff0266),
                                  onPressed: () {setState(() {
                                    if(bu_click == 0)
                                    {
                                      tts_bu = "Stop";
                                      bu_click++;
                                      speak(widget.explain);
                                    }else{
                                      tts_bu="Speak";
                                      bu_click--;
                                      stop();
                                    }
                                  });
                                  },
                                  child: Text(tts_bu),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                      color: Color(0xffffe0bd),
                    ),
                    child: Center(
                      child: ExpansionTile(
                        backgroundColor: Color(0xffffffff),
                        title: Text("Important Question", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,), textAlign: TextAlign.center, softWrap: true,),
                        children: <Widget>[
                          //important question
                          Container(
                            height: 200,
                            child: ListView.builder(
                                itemCount: widget.iqa.length,//widget.ques.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  if(index%2==0){
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10, left: 10, bottom: 15, right: 10),
                                      child: Container(
                                          child:Wrap(
                                            children: <Widget>[
                                              Text("\n\n\n"+widget.iqa[index], style: TextStyle(fontWeight: FontWeight.bold),),
                                              // Text(widget.ans[index]+"\n\n\n")
                                            ],
                                          )
                                      ),
                                    );
                                  }
                                  else
                              return Padding(
                                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 15, right: 10),
                                child: Container(
                                    child:Wrap(
                                      children: <Widget>[
                                        Text(widget.iqa[index]+"\n\n",),
                                       // Text(widget.ans[index]+"\n\n\n")
                                      ],
                                    )
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>get_quiz_main(title: widget.title, des: widget.des, explain: widget.explain, qus: widget.qus,
          ops: widget.ops, ran: widget.ran, iqa: widget.iqa,)));
        }, shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),

        ),
          child: Icon(Icons.library_books, color: Color(0xffffffff),),
        ),
      ),
    );
  }
}

class get_quiz_main extends StatefulWidget{
  get_quiz_main({this.title, this.des, this.explain, this.qus, this.ops, this.ran, this.iqa});
  String title;
  String des;
  String explain;
  var qus=[];
  var ops=[];
  var ran=[];
  var iqa=[];

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return get_quiz_main_state();
  }

}
String title, description, explanation;
class get_quiz_main_state extends State<get_quiz_main>{
  Future<bool> _backpressed() async{
    //page_id=2;
    Navigator.push(context, MaterialPageRoute(builder: (context)=>english_ch_detail(title: title,
      des: description, explain: explanation, qus: ques, ops: ans, ran: rans, iqa: iqae,
    )));
    return await false;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _backpressed,
      child: Scaffold(
        backgroundColor: Color(0xffff0266),
        body: get_quiz(),
      ),
    );
  }

}

Widget description_section(String des){
  return Padding(
    padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
    child: Container(
      child: Text(des, style: TextStyle(wordSpacing: 5, letterSpacing: 2, fontSize: 20), textAlign: TextAlign.left,),
    ),
  );
}
FlutterTts flutterTts = new FlutterTts();
speak(String des) async{
  var result = flutterTts.speak(des);
  return result;
}

stop() async{
  var result = await flutterTts.stop();
}

var ques=[];
var ans=[];
var rans=[];


Widget get_quiz(){
  var i=new Random();
  int sel = i.nextInt(ques.length);
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Center(child: quiz(ques: ques[sel], o1: ans[sel*3+0], o2: ans[sel*3+1], o3: ans[sel*3+2], rans: rans[sel],)),
    ],
  );
}

class quiz extends StatefulWidget{
  quiz({this.ques, this.rans, this.o1, this.o2, this.o3});
  String ques;
  String o1,o2,o3,rans;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return quiz_state();
  }

}

class quiz_state extends State<quiz>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Text(widget.ques, softWrap: true, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Color(0xffffcc00)),),
          ),
        ),
        Container(
            child: Column(
              children: <Widget>[
                FlatButton(onPressed: (){
                  if(widget.rans == widget.o1){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>get_quiz_main(title: title,
                      des: description, explain: explanation, qus: ques, ops: ans, ran: rans, iqa: iqae,
                    )));
                  }
                }, child: Container(
                  color: Color(0x30ffffff),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.o1, style: TextStyle(color: Color(0x500000ff), fontSize: 20),),
                      ),
                    ],
                  ),
                ),
                ),
                FlatButton(onPressed: (){
                  if(widget.rans == widget.o2){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>get_quiz_main(title: title,
                      des: description, explain: explanation, qus: ques, ops: ans, ran: rans, iqa: iqae,
                    )));
                  }
                }, child: Container(
                  color: Color(0x30ffffff),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.o2, style: TextStyle(color: Color(0x500000ff), fontSize: 20)),
                      ),
                    ],
                  ),
                ),),
                FlatButton(onPressed: (){
                  if(widget.rans == widget.o3){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>get_quiz_main(title: title,
                      des: description, explain: explanation, qus: ques, ops: ans, ran: rans, iqa: iqae
                    )));
                  }
                }, child: Container(
                  color: Color(0x30ffffff),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.o3, style: TextStyle(color: Color(0x500000ff), fontSize: 20)),
                      ),
                    ],
                  ),
                ),),
              ],
            )
        )
      ],
    );;
  }

}