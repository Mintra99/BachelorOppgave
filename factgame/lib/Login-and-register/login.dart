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

class LogIn extends StatefulWidget{
  LogIn({Key key}) : super(key: key);


  @override
  LogInState createState() => LogInState();
}
class LogInState extends State<LogIn> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  String msgStatus='' ;

  _onPressed(){
    setState(() {
      if(_usernameController.text.trim().toLowerCase().isNotEmpty &&
          _passController.text.trim().isNotEmpty ){
        databaseHelper.loginData(_usernameController.text.trim().toLowerCase(),
            _passController.text.trim()).whenComplete((){
          if(databaseHelper.errorMessage){
            _showDialog();
            msgStatus = 'Check email or password';
          }else{
             Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Login', style: TextStyle(fontSize: 32),),
                SizedBox( height: 20,),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(Icons.person,size: 40,color: Colors.blue,),
                    labelText: "Username",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                        )
                    ),

                  ),),
                Padding(padding: EdgeInsets.only(top:20)),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(Icons.lock,size: 40,color: Colors.blue,),
                    labelText: "Password",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                        )
                    ),

                  ),),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/ForgotPassword'),
                  child: Text(
                    'Forgot Password?', style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                SizedBox(height: 25,),
                SizedBox(
                    width:500,height: 50,
                    child:RaisedButton(
                      color: Colors.lightGreenAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Text('Sign In',style: TextStyle(fontSize: 32)),
                      onPressed: _onPressed,
                    )),
                Padding(padding: new EdgeInsets.only(top: 44.0),),
                SizedBox(
                    height: 50,
                    child: new Text(
                      '$msgStatus',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox( height: 20,),
                FlatButton( child: Text('Create New Account',),splashColor: Colors.lightGreenAccent,
                  onPressed: (){
                    Navigator.pushNamed(context, '/CreateNewAccount');
                  },
                )
              ],
            ),
          )
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
