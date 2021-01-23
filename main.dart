import 'package:fakenews/pages/mobiledetails.dart';

import 'package:factgame/sections.dart';
import "package:flutter/material.dart";
import 'factgame/lib/home.dart';
import 'factgame/lib/sections.dart';
import 'factgame/lib/samsung.dart';
import 'factgame/lib/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mobtech",
      home: Home(),
      routes: {
        'sections': (context){
        return Sections();
        },
        'HomePage':(context){
          return Home();
        },
        'Samsung':(context){
          return Samsung();
        },
        'mobiledetails':(context){
          return MobileDetails();
        },
        "login":(context){
          return LogIn();
        },
      },
    );
  }
}

