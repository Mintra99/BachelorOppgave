import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper{

  String serverUrl = "https://fakenews-app.com/api/users";
  var errorMessage ;
  var Message;

  var token ;


  void answerData(String answer_text, int questionid) async{
    answer_text = answer_text.toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0 ;
    String myUrl = "https://fakenews-app.com/api/game/answer_single/";
     http.post(myUrl,
        headers: {
          'Authorization': 'Bearer $value'
        },
        body: {
          "answer_text": "$answer_text",
          "questionid" : "$questionid",
        }).then((response){
       print('Response status : ${response.statusCode}');
       print('Response status : ${response.body} ');
       var data = json.decode(response.body);
       var dataScore= data["score"];
       prefs.setInt('score', dataScore);
    });

  }

  loginData(String username , String password) async{

    String myUrl = "$serverUrl/login/?format=json";
    final response = await  http.post(myUrl,
        body: {
          "username": "$username",
          "password" : "$password",
        } ) ;
    errorMessage = response.body.contains('No active account');

    var data = json.decode(response.body);
    if(errorMessage){
      print('No active account ${data}');
    }else{
      print('data : ${data["access"]}');
      _save(data["access"]);
    }

  }

  registerData(String username ,String email , String password) async{

    String myUrl = "$serverUrl/register";
    final response = await  http.post(myUrl,
        headers: {
          'Accept':'application/json'
        },
        body: {
          "username": "$username",
          "password" : "$password",
          "email": "$email",
          'first_name': "",
          'last_name' : "",
        } ) ;
    //errorMessage = response.body.contains('error');

    var data = json.decode(response.body);
    print("message");
    print(data["message"]);

    //Message = data["message"].contains('User Created Successfully');

    if (data["message"] == null) {
      print("test");
    } else {
      Message = data["message"].contains('User Created Successfully');
    }


    // errorMessage = data['message'].contains("This field may not be blank.") || data['message'].contains("Enter a valid email address.");

    //print(data)
    if(Message){
      print('data : ${data["message"]}');
    }else{
      print('data : ${data["error"]}');
    }
  }


  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = token;
    prefs.setString(key, value);
  }


  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }


  
}
