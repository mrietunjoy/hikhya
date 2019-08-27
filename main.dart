import 'package:flutter_linux_first/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
          seconds: 5,
          navigateAfterSeconds: new main_screen(),
          image: Image(image: AssetImage("icons/ico.png"), color: Color(0xfff3e8e5),fit: BoxFit.contain, width: 100, height: 120,),
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 120.0,
          title: Text("HIKHYA", style: TextStyle(fontFamily: "chalk", color: Color(0xfff3e8e5), fontSize: 20),),
          loaderColor: Color(0xfff3e8e5),
        imageBackground: AssetImage("icons/icon_back2.jpg"),
      );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Welcome In SplashScreen Package"),
          automaticallyImplyLeading: false
      ),
      body: new Center(
        child: new Text("Done!",
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0
          ),),

      ),
    );
  }
}