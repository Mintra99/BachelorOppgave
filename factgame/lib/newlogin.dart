import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' ;
import 'package:email_validator/email_validator.dart';

import 'home.dart';

class LogIn extends StatefulWidget{
  LogIn({Key key}) : super(key: key);

  @override
  LogInState createState() => LogInState();
}
class LogInState extends State<LogIn> {
  TextEditingController _userControler = TextEditingController();
  TextEditingController _passControler = TextEditingController();

  bool _isloading = false;
  signIn(String user, String pass)async{
    print('print sign in result');
    print(context);
    String url = "http://localhost:3000/api/users/login/";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body={"username":user,"password":pass};
    var jasonResponse;
    var res = await http.post(url,body : body);
    print(res);
    if(res.statusCode == 200){
      jasonResponse = json.decode(res.body);
      print("jason answer${res.statusCode}");
      print("body${res.body}");
      if(jasonResponse != null){
        setState(() {
          _isloading = false;
        });
        sharedPreferences.setString("token",  jasonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Home()),
                (Route<dynamic>route) => false);
      }else{
        setState(() {
          _isloading = false;
          print("else${res.body}");
        });
      }
    }
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
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.blueGrey[100],
                  prefixIcon: Icon(Icons.email,size: 40,color: Colors.blue,),
                  labelText: "Email",
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
            onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
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
                  onPressed: _userControler == '' || _passControler == ''
                      ? null
                      :(){
                    setState(() {
                      _isloading = true;
                    });
                    signIn(_userControler.text, _passControler.text);
                  }
              )),
        SizedBox( height: 20,),
        FlatButton( child: Text('Create New Account',),splashColor: Colors.lightGreenAccent,
          onPressed: (){
            Navigator.pushNamed(context, 'CreateNewAccount');
          },
              )
            ],
          ),
        )
      ),
    );
}}