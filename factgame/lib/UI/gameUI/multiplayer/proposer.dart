import 'dart:async';
import 'dart:math';
import 'package:factgame/UI/gameUI/multiplayer/guesser.dart';
import 'package:factgame/UI/lobby/lobbydatabasehelper.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:factgame/Controllers/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:factgame/UI/gameUI/endscreen.dart';

class Hint {
  String id;
  String hintText;

  Hint(this.id, this.hintText);
}

class ProposerManager extends StatefulWidget {
  final String title;
  final List listOfQuestions;

  ProposerManager({Key key, this.title, this.listOfQuestions})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProposerPageState();
  }
}

class _ProposerPageState extends State<ProposerManager> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  LobbydatabaseHelper lobbydatabaseHelper = new LobbydatabaseHelper();
  MultiPlayer MP = new MultiPlayer();

  int timer = 10;
  double percentage;
  bool canceltimer = false;
  String showtimer = "10";
  String stringResponse;

  //List mapResponse;
  String question;
  String answer;
  int questionid;
  int score = 0;
  List hint;

  String _selected;
  List<Map> _myJson = [
    {"id": '1', "name": "Affin Bank"},
    {"id": '2', "name": "Ambank"},
    {"id": '3', "name": "Bank Isalm"},
    {"id": '4', "name": "Bank Rakyat"},
  ];

  Future fitchData() async {
    if (widget.listOfQuestions == null) {
      print('nooooooooo');
    } else {
      showQuestion();
    }
  }

  void showQuestion() {
    if (widget.listOfQuestions.length > 0) {
      question = widget.listOfQuestions[0]['question_text'].toString();
      answer = widget.listOfQuestions[0]['correct_answer'].toString();
      hint = widget.listOfQuestions[0]['doc'].split("\" ");
      _selected = hint[0];
      print("HINT!!!!!!");
      print(hint);
      answer.toLowerCase();
      print(answer);
      questionid = widget.listOfQuestions[0]['id'].toInt();
      print('question id that we like it : $questionid');
      //lobbydatabaseHelper.addGameClaim(questionid);
    } else {
      //MP.dataQ = null;
      canceltimer = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameFinishedManager()),
      );
    }
    widget.listOfQuestions.removeAt(0);
  }

  @override
  void initState() {
    print("LISTOFHINT");
    print(widget.listOfQuestions[0]['doc']);
    fitchData();
    starttimer();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
        percentage = timer.toDouble() / 10.0;
      });
    });
  }

  void nextquestion() {
    showQuestion();
    canceltimer = false;
    timer = 10;
    starttimer();
  }

  void checkanswer(String k) async {
    databaseHelper.answerData(k, questionid);
    k.toLowerCase();
    print(k.toLowerCase());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (answer == k.toLowerCase()) {
      score += 1;
      prefs.setInt('guesserScore',
          score); // we set key(guesserScore) and value(score) score: is the update score for player, and we set this integer in local Storage
      print('correct');
    } else {
      print('wrong');
    }
    setState(() {
      canceltimer = true;
    });
    //adds delay so the user can see the answer
    Timer(Duration(seconds: 2), nextquestion);
  }

  Widget hintButton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () {
          checkanswer(k);
        },
        child: Text(
          k.toString(),
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        //color: hints[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    BackButton(),
                    Spacer(),
                    Text('Score:' + '$score'),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Container(
                padding: EdgeInsets.all(15.0),
                child: widget.listOfQuestions == null
                    ? Container()
                    : Text(
                        // Shows the question to the guesser
                        '$question',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Quando",
                        ),
                      ),
              ),
              SizedBox(height: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<dynamic>(
                          isDense: true,
                          value: _selected,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              _selected = newValue;
                            });
                            print(_selected);
                          },
                          items: hint
                              .map<DropdownMenuItem<dynamic>>((dynamic value) {
                            return new DropdownMenuItem<dynamic>(
                              value: value,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                      width: 300,
                                      child: Center(
                                          child:
                                          Text(value.toString()),
                                      )
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: RaisedButton(
                  child: Text('Send hint'),
                  onPressed: () {
                    print('question id appear when u press send hint');
                    print(questionid);
                    //lobbydatabaseHelper.addGameClaim(questionid);
                    // Todo update endpoint with question hint
                    lobbydatabaseHelper.setHint(_selected);
                  },
                ),
              ),
              //SizedBox(height: 150),
              new Container(
                child: Column(
                  children: [
                    Container(
                        width: 250,
                        child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.grey,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ))),
                    Container(
                      child: Text(
                        '$timer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
