import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:factgame/Controllers/databasehelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' ;
import 'package:email_validator/email_validator.dart';

import '../home.dart';

class ShowData extends StatefulWidget{

  List list;
  int index;
  ShowData({this.index , this.list}) ;


  @override
  ShowDataState  createState() => ShowDataState();
}

class ShowDataState extends State<ShowData> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        appBar: AppBar(
          title:  Text('Login'),

        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(top: 62,left: 12.0,right: 12.0,bottom: 12.0),
            children: <Widget>[

              Container(
                height: 50,
                child: new Text(
                  "Username : ${ widget.list[widget.index]['username']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new Padding(padding: new EdgeInsets.only(top: 44.0),),

            ],
          ),
        ),
      ),
    );
  }



  void _showDialog(){
    showDialog(
        context:context ,
        builder:(BuildContext context){
          return AlertDialog(
            title: new Text('Failed'),
            content:  new Text('Check your email or password'),
            actions: <Widget>[
              new RaisedButton(

                child: new Text(
                  'Close',
                ),

                onPressed: (){
                  Navigator.of(context).pop();
                },

              ),
            ],
          );
        }
    );
  }



}
