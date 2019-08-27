import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_linux_first/main_screen.dart';

class jwords extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return jwstate();
  }

}

class jwstate extends State<jwords>{

  var bottom_select = 2;
  bool is_select = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffe63c8e),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
        child: Container(
          //get the games
          child: get_games(),
        ),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: Color(0xff0336ff),
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Color(0xffff0266),
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
            BottomNavigationBarItem(icon: Icon(Icons.games), title: Text('Fun')),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), title: Text('Notice')),
          ],
          onTap: (isset){
            setState(() {
              bottom_select=isset;
              if(bottom_select==1){
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>elective_selection()));
              }else if(bottom_select==0){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>main_screen()));
              }
            });
          },
        ),
      ),
    );
  }

}


class DragObject extends StatefulWidget{
  DragObject({this.textData});
  String textData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DragObjectState();
  }
}

class DragObjectState extends State<DragObject>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Draggable(
      data: widget.textData,
      child: Text(widget.textData, style: TextStyle(fontSize: 25, color: Color(0xffffffff)),),
      feedback: Text(widget.textData, style: TextStyle(fontSize: 25, color: Color(0xffffffff)),),
      childWhenDragging: Text(widget.textData, style: TextStyle(fontSize: 25, color: Color(0x40ffffff),),),
      onDragCompleted: (){
        setState(() {
          if(acc == 1)
            widget.textData="";
        });
      },
    );
  }

}

class Dragtarget extends StatefulWidget{
  Dragtarget({this.data_string});
  String data_string;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DragTargetState();
  }

}
int acc=0;
String word_given;
var word_length=[];
class DragTargetState extends State<Dragtarget>{
  bool accepted = false;
  String accepted_string="";
  String dis_text="";
  int colur=0xffffcc00;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(colur),),
          width: 50,
          height: 50,
          child: DragTarget(builder: (context, List<String> candidateData, rejectedData){
            return Center(child: accepted? Text('accepted'): Container(child: Text(dis_text, style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold, fontSize: 25),),));
          },
            onWillAccept: (data){
              setState(() {
                colur=0x80ff0000;
              });
              return true;
            },
            onLeave: (data){
              setState(() {
                colur=0xffffcc00;
              });
              return true;
            },
            onAccept: (data){
              accepted=false;
              setState((){accepted_string = widget.data_string;});
              if(data == widget.data_string) {
                setState((){
                  dis_text = data;
                  word_length.add(data);
                });
                if(word_length.length == word_given.length)
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>jwords()));
                acc=1;
                return true;
              }
              else{
                acc=0;
                accepted=false;
                setState((){dis_text = "Not Accepted"; colur=0xff808080;});
                return false;
              }

            },
          )
      );
  }
}

Column get_games(){
  var ik=new Random();
  int kit=ik.nextInt(2);
  if(kit ==1) {
    word_length.clear();
    List<String> words = [
      "APPLE", "BALL", "CRICKET", "BALOON", "WIDGET", "FOOTBALL"];
    var i = new Random();
    int k = i.nextInt(words.length);
    word_given=words[k];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        get_row(words[k]),
        get_wrap(words[k]),
        //add contents
      ],
    );
  }else if(kit==0){
    return get_quiz();
  }
}

Widget get_row(String words){
  var word_select=words.split('');
  var word_now=[];
  var random_int = new Random();
  while(word_select.length!= word_now.length){
    int i=random_int.nextInt(word_select.length);
    if(word_select[i] != ""){
      word_now.add(word_select[i]);
      word_select[i]="";
    }
  }
  return Container(
    height: 200,
    alignment: Alignment.center,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
    itemCount: word_now.length,
      itemBuilder: (BuildContext context, int index) {return get_dragobject(word_now[index]);},
    ),
  );
}

get_dragobject(String word){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DragObject(textData: word),
    );
}

Widget get_wrap(String words){
  var word_select=words.split('');
  return
    Wrap(
       children: <Widget>[
         Container(
           height: 70,
           alignment: Alignment.center,
           child: ListView.builder(
             shrinkWrap: true,
             scrollDirection: Axis.horizontal,
             itemCount: word_select.length,
             itemBuilder: (BuildContext context, int index) {return get_dragtarget(word_select[index]);},
           ),
         ),
       ],
    );
}

get_dragtarget(String word){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Dragtarget(data_string: word,),
    );
}


Widget get_quiz(){
  var ques=["Who are you", "Where do you live?"];
  var ans=["Riju", "Hola", "Cla", "GHY", "KYQ", "KOL"];
  var rans=["Riju", "KYQ"];
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>jwords()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>jwords()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>jwords()));
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