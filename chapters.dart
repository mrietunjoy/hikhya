import 'package:flutter/material.dart';
import 'package:flutter_linux_first/english_ch_detail.dart';
import 'package:flutter_linux_first/main_screen.dart';
import 'package:path/path.dart';
class chapters extends StatefulWidget{
  chapters({this.sub, this.chlist, this.chdes, this.chexp});
  String sub;
  var chlist=[];
  var chdes=[];
  var chexp=[];
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return chapters_state();
  }
}

class chapters_state extends State<chapters>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffff6600),
      body: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 30, top: 50, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Select', style: TextStyle(fontFamily: 'Rubik', fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xffffffff)),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Chapter', style: TextStyle(fontFamily: 'Rubik', fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xffffffff)),),
                    ],
                  ),
                ],
              )
          ),
          select_subject(widget.sub, widget.chlist, widget.chdes, widget.chexp)
        ],
      )
    );
  }
}

Column select_subject(String sub, List chlist, List chdes, List chexp) {
  subject=sub;
  switch(sub){
    case "English":
      return Column(
        children: <Widget>[
          chapter_design(des: chdes[0], chapter_name: chlist[0], explanation: chexp[0],),
      chapter_design(des: chdes[1], chapter_name: "Nelson Mandela: Long Walk To\nFreedom", explanation: chexp[1]),
          chapter_design(des: chdes[2], chapter_name: chlist[2], explanation: chexp[2]),
        ],
  );
      break;
    case "Maths":
      return Column(
      children: <Widget>[
        //chapter_design(chapter_no: "1", chapter_name: "Real Numbers",),
      ],
    );
      break;
    case "Science":
        return Column(
          children: <Widget>[
            chapter_design(des: "WHAT ARE LIFE PROCESSES?\nThe maintenance functions of living organisms must go on even when they are not doing anything particular. The processes which together perform this maintenance job are life processes. ",
              chapter_name: "Life Processes",
              explanation: "The maintenance functions of living organisms must go on even when they are not doing anything particular. The processes which together perform this maintenance job are life processes.\n\nSince these maintenance processes are needed to prevent damage and break-down, energy is needed for them. This energy comes from outside the body of the individual organism. So there must be a process to transfer a source of energy from outside the body of the organism, which we call food, to the inside, a process we commonly call nutrition.",),
          ],
        );
      break;
    default: ;
  }
}

class chapter_design extends StatefulWidget{
  chapter_design({this.explanation, this.chapter_name, this.des});
  String explanation;
  String chapter_name;
  String des;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return chapter_design_state();
  }
}
String subject;
class chapter_design_state extends State<chapter_design>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: RaisedButton(
              elevation: 8,
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30))
              ),
              padding: EdgeInsets.only(left: 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Text(
                        widget.chapter_name,
                        softWrap: true,
                        style: TextStyle(fontFamily: 'Rubik',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ), onPressed: () {
                //goto_det(widget.chapter_name, context);
              var ques;
              var ans;
              var rans;
              var iqa=[];
              if(widget.chapter_name=="A Letter to God") {
                ques=["What did Lencho wish for", "Whom did Lencho write letter to?"];
                ans=["Gold", "Rain", "Become God", "God", "Judge", "His Sons"];
                rans=["Rain", "God"];
                iqa=["What did Lencho hoped for?", "Lencho hoped for rains", "How did the rain change?", "The rain was pouring, but suddenly strong wind began to blow, and hail stone started to fall along with the rain."];
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    english_ch_detail(title: widget.chapter_name,
                      des: widget.des,
                      explain: widget.explanation,
                      qus: ques,
                      ops: ans,
                      ran: rans,
                      iqa: iqa,
                    )));
              }else if(widget.chapter_name=="Life Processes"){
                ques=["The processs of break down of food for cellular need is called?", "Green Plants falls under which category"];
                ans=["Respiration", "Breathing", "Cutting", "automobile", "Autotrophs", "heterotrophs"];
                rans=["Respiration", "Autotrophs"];
                iqa=["What are outside Raw materials used for in organism?", "Organisms uses raw materials in the form of food and oxygen.", "What processes are essential for maintaining life?", "Life processes like nutrition, respiration, excretion, etc, are important for maintaning life."];
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    english_ch_detail(title: widget.chapter_name,
                      des: widget.des,
                      explain: widget.explanation,
                      qus: ques,
                      ops: ans,
                      ran: rans,
                      iqa: iqa,
                    )));
              }else{
                //ques=["The processs of break down of food for cellular need is called?", "Green Plants falls under which category"];
                //ans=["Respiration", "Breathing", "Cutting", "automobile", "Autotrophs", "heterotrophs"];
                //rans=["Respiration", "Autotrophs"];
                //iqa=["What are outside Raw materials used for in organism?", "Organisms uses raw materials in the form of food and oxygen.", "What processes are essential for maintaining life?", "Life processes like nutrition, respiration, excretion, etc, are important for maintaning life."];

                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    english_ch_detail(title: widget.chapter_name,
                      des: widget.des,
                      explain: widget.explanation,
                      qus: ques,
                      ops: ans,
                      ran: rans,
                      iqa: iqa,
                    )));
              }
              },
            ),
          )
        ],
      ),
    );
  }
  goto_det(String ch_name, BuildContext con){
    String des;
    String explanation;
    var question=[];
    var answer=[];
    if(ch_name == "A Letter To God"){
      des="THE house — the only one in the entire valley — sat on the crest of a low hill. From this height one could see the river and the field of ripe corn dotted with the flowers that always promised a good harvest. The only thing the earth needed was a downpour or at least a shower. Throughout the morning Lencho — who knew his fields intimately — had done nothing else but see the sky towards the north-east."+"\n\"Now we’re really going to get some water, woman.\""+
    "\n\n\n     The woman who was preparing supper, replied, “Yes, God willing”. The older boys were working in the field, while the smaller ones were playing near the house until the woman called to them all, “Come for dinner”. It was during the meal that, just as"+
    "Lencho had predicted, big drops of rain began to fall. In the north-east huge mountains of clouds could be seen approaching. The air was fresh and sweet. The man went out for no other reason than to have the pleasure of feeling the rain on his body, and when he returned he exclaimed, ‘‘These aren’t raindrops falling from the sky, they are new coins. The big drops are ten cent pieces and the little ones are fives.\""+
    "\n\n\n     With a satisfied expression he regarded the field of ripe corn with its flowers, draped in a curtain of rain. But suddenly a strong wind began to blow and along with the rain very large hailstones began to fall. These truly did resemble new silver coins. The boys, exposing themselves to the rain, ran out to collect the frozen pearls."+
    "\n\n\n     \"It’s really getting bad now,\" exclaimed the man. \“I hope it passes quickly.\” It did not pass quickly. For an hour the hail rained on the house, the garden, the hillside, the cornfield, on the whole valley. The field was white, as if covered with salt."+
    "\n\n\n     Not a leaf remained on the trees. The corn was 4 totally destroyed. The flowers were gone from the plants. Lencho’s soul was filled with sadness. When the storm had passed, he stood in the middle of the field and said to his sons, \“A plague of locusts would have left more than this. The hail has left nothing. This year we will have no corn.\""+
    "\n\n\n     That night was a sorrowful one. “All our work, for nothing.” ‘‘There’s no one who can help us.” “We’ll all go hungry this year.”"+
    "\n\n\n     But in the hearts of all who lived in that solitary house in the middle of the valley, there was a single hope: help from God."+
    "\n\n\n     “Don’t be so upset, even though this seems like a total loss. Remember, no one dies of hunger.\”"+
    "\“That’s what they say: no one dies of hunger.”\""+
    "\n\n\n     All through the night, Lencho thought only of his one hope: the help of God, whose eyes, as he had been instructed, see everything, even what is deep in one’s conscience. Lencho was an ox of a man, working like an animal in the fields, but still he knew how to write. The following Sunday, at daybreak, he began to write a letter which he himself would carry to town and place in the mail. It was nothing less than a letter to God.@"+
    "\n\n\n     \“God,” he wrote, “if you don’t help me, my family and I will go hungry this year. I need a hundred pesos in order to sow my field again and to live until the crop comes, because the hailstorm....\”"+
    "\n\n\n     He wrote ‘To God’ on the envelope, put the letter inside and, still troubled, went to town. At the post office, he placed a stamp on the letter and dropped it into the mailbox."+
    "One of the employees, who was a postman and also helped at the post office, went to his boss laughing heartily and showed him the letter to God. Never in his career as a postman had he known that address. The postmaster — a fat, amiable@"+
    "fellow — also broke out laughing, but almost immediately he turned serious and, tapping the letter on his desk, commented, “What faith! I wish I had the faith of the man who wrote this letter. Starting up a correspondence with God!”"+
    "\n\n\n     So, in order not to shake the writer’s faith in God, the postmaster came up with an idea: answer the letter. But when he opened it, it was evident that to answer it he needed something more than goodwill, ink and paper. But he stuck to his resolution: he asked for money from his employees, he himself gave part of his salary, and several friends of his were obliged to give something ‘for an act of charity’.@"+
    "\n\n\n     It was impossible for him to gather together the hundred pesos, so he was able to send the farmer only a little more than half. He put the money in an envelope addressed to Lencho and with it a letter containing only a single word as a signature: God."+
    "\n\n\n     The following Sunday Lencho came a bit earlier than usual to ask if there was a letter for him. It was the postman himself who handed the letter to him while the postmaster, experiencing the contentment of a man who has performed a good deed, looked on from his office.@"+
    "\n\n\n     Lencho showed not the slightest surprise on seeing the money; such was his confidence — but he became angry when he counted the money. God could not have made a mistake, nor could he have denied Lencho what he had requested."+
    "\n\n\n     Immediately, Lencho went up to the window to ask for paper and ink. On the public writing-table, he started to write, with much wrinkling of his brow, caused by the effort he had to make to express his ideas. When he finished, he went to the window to buy a stamp which he licked and then affixed to the envelope with a blow of his fist. The moment the letter fell into the mailbox the postmaster went to open it. It said: “God: Of the money that I asked for, only seventy pesos reached me. Send me the rest, since I need it very much. But don’t send it to me through the mail because the post office employees are a bunch of crooks. Lencho.”";
      explanation="This story is written by G L Fuentes. This is a story about the great faith of a simpleton in the God. The story begins with Lencho hoping for rains so that his crops would give a better yield. The rain does come but is followed by a devastating hailstorm. Hailstorm destroys all the standing crops and leaves Lencho staring into the bleak future ahead. But Lencho is a strong believer in the God and decides to write a letter to the God; asking for some monetary help. Lencho also wishes to repay the debt when the next crop would give him enough money. After seeing Lencho’s letter, the postmaster is deeply touched by the strong faith of Lencho in the God. The postmaster collects money from his colleagues and sends some money to Lencho. But the money sent by the postmaster is less than what the Lencho had demanded through his letter. Lencho once again writes a letter to the God in which he expresses his doubts about the honesty of post office employees.";
      if(question.isNotEmpty)
        question.clear();
      if(!answer.isNotEmpty)
        answer.clear();
      question.add("What did Lencho hope for?");
      answer.add("Lencho hoped for rains; because the crop in his field needed rains.");
      question.add("Why did Lencho say the raindrops were like ‘new coins’?");
      answer.add(" As raindrops would have helped in getting a better harvest, resulting in more prosperity, so Lencho compared them with new coins.");
      //Navigator.push(con, MaterialPageRoute(builder: (context)=>english_ch_detail(title: ch_name, des: des, explain: explanation, ques: question, ans: answer,)));
    }else if(ch_name == "Nelson Mandela: Long Walk To\nFreedom"){
      final snb = SnackBar(content: Text('Yet to be added'),);
      Scaffold.of(con).showSnackBar(snb);
    }
    else if(ch_name == "Real Numbers"){
      //Navigator.push(con, MaterialPageRoute(builder: (context)=>english_ch_detail(title: ch_name,)));
      final snb = SnackBar(content: Text('Yet to be added'),);
      Scaffold.of(con).showSnackBar(snb);
    }
  }
}
