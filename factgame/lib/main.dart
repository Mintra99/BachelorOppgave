import "package:flutter/material.dart" show BuildContext, MaterialApp, StatelessWidget, Widget, runApp;
import 'home.dart';
import './Login-and-register/forgetpassword.dart';
import './Login-and-register/login.dart';
import './Login-and-register/createnewaccount.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mobtech",
      home: LogIn(),
      routes: {
        //here is function for login and register
        '/home': (context) => Home(),
        '/Login': (context) => LogIn(),
        '/ForgotPassword': (context) => ForgotPassword(),
        '/CreateNewAccount': (context) => CreateNewAccount(),
        //here is the end of functuon login and register
        '/HomePage':(context){
          return Home();
        },
      },
    );
  }
}

