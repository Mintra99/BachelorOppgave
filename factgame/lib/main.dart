//import 'package:fakenews/pages/mobiledetails.dart';
//import 'package:factgame/sections.dart';
//import 'sections.dart';

import "package:flutter/material.dart" show BuildContext, MaterialApp, StatelessWidget, Widget, runApp;
import 'home.dart';
import 'samsung.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mobtech",
      home: Home(),
      //home: LogIn //bytt til denne når login er ferdig
      routes: {
        /*
        'sections': (context){
        return Sections();
        },

         */
        'HomePage':(context){
          return Home();
        },
        'Samsung':(context){
          return Samsung();
        },
        /*
        'mobiledetails':(context){
          return MobileDetails();
        },

         */
        "login":(context){
          return LogIn();
        },
      },
    );
  }
}

