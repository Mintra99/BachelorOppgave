import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lobbydatabasehelper.dart';

void main() => runApp(YourApp());

class YourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectQuestion(),
    );
  }
}

class SelectQuestion extends StatefulWidget {
  @override
  _SelectQuestionState createState() => _SelectQuestionState();
}

class _SelectQuestionState extends State<SelectQuestion> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  List _myActivities;
  String _myActivitiesResult;
  final formKey = new GlobalKey<FormState>();
  List questions = [];
  int gameId;
  int Id;

  @override
  void initState() {
    Question();
    getQuestion();
    super.initState();
    _myActivities = [];
  }

  Future getQuestion() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    var response = await http.get('https://fakenews-app.com/api/game/question/', headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
    );
    var jsonData = json.decode(response.body);
    for (var u in jsonData) {
      String display = (u["question_text"]);
      Question singleQuestion = Question(display: display, value: u);
      questions.add(singleQuestion);
    }
   // return questions;
  }
  _saveForm() async{
    var form = formKey.currentState;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (form.validate()) {
      form.save();
      setState(() {

        databaseHelper.addGameQuestions(_myActivities);
      });
    }
  }

  /*List<Question> getList() {
    List<Question> list = [];
    for (int i = 0; i< questions.length; i++) {
      list.add(Question(display: questions[i].display, value: questions[i].value
      ));
    }
    return list;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MultiSelect Formfield Example'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: MultiSelectFormField(
                  autovalidate: false,
                  chipBackGroundColor: Colors.red,
                  chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  checkBoxActiveColor: Colors.red,
                  checkBoxCheckColor: Colors.green,
                  dialogShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  title: Text(
                    "Questions",
                    style: TextStyle(fontSize: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please select ten questions';
                    }
                    return null;
                  },
                  dataSource: [
                    // Todo insert question list inside dataSource
                    //getList(),
                    for (var i = 0; i < questions.length; i++)
                      {
                        "display": questions[i].display,
                        "value": questions[i].value,
                      },

                  ],
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintWidget: Text('Please choose ten question'),
                  initialValue: _myActivities,
                  onSaved: (value) {
                    if (value == null) return;
                    setState(() {
                      _myActivities = value;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: RaisedButton(
                  child: Text('Save'),
                  onPressed: _saveForm,
                ),
              ),
              /*Container(
                padding: EdgeInsets.all(16),
                child: Text(_myActivitiesResult),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  Question({this.display, this.value});

  final String display;
  Map value;
}
