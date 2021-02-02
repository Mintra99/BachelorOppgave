import 'package:fakenews/pages/mobiledetails.dart';

import 'package:fakenews/sections.dart';
import 'package:flutter/material.dart';
import './home.dart';
import './sections.dart';
import 'samsung.dart';
import './newlogin.dart';
import './createnewaccount.dart';
import './forgetpassword.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' ;
import './hope.dart';


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
        //here is function for login and register
        'Login': (context) => LogIn(),
        'ForgotPassword': (context) => ForgotPassword(),
        'CreateNewAccount': (context) => CreateNewAccount(),
        //here is the end of functuon login and register

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

