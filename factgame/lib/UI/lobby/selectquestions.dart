import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SelectQuestion extends StatefulWidget {
  SelectQuestion({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectQuestionState createState() => new _SelectQuestionState();
}

class _SelectQuestionState extends State<SelectQuestion> {

  Future<List<Question>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    var response = await http.get('https://fakenews-app.com/api/game/question/',headers: {HttpHeaders.authorizationHeader: "Bearer $value"},);
    var jsonData = json.decode(response.body);
    List<Question> questions = [];
    for(var u in jsonData){
      Question user = Question(u["question_text"]);
      questions.add(user);
    }
    print(questions.length);
    return questions;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Select ten question'),
      ),
      body: Container(
        child: FutureBuilder(
          future: getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                  child: Center(
                      child: Text("Loading...")
                  )
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].question_text),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}



class Question {
  final String question_text;
  Question(this.question_text);

}