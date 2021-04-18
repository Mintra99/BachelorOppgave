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
  final int playerNum;

  ProposerManager({Key key, this.title, this.listOfQuestions, this.playerNum})
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

  int timer = 45;
  double percentage;
  bool canceltimer = false;
  String showtimer = "10";
  String stringResponse;

  //List mapResponse;
  String question;
  String answer;
  int questionid;
  int score = 0;
  String hint;
  List splitHint = [];

  List playerIDList = [];
  List scoreList = [];

  String _selected;

  int playerID;
  RegExp re = new RegExp(r"(\w|\s|,|')+[。.?!]*\s*");

  Future fitchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    playerID = prefs.getInt('playerID') + 1;
    for(int i = 1; i < widget.playerNum; i++){
      print("PLAYERID");
      playerIDList.add(prefs.getInt('playerID') + i);
      print(playerIDList);
    }
    if (widget.listOfQuestions == null) {
      print('nooooooooo');
    } else {
      showQuestion();
    }
  }

  Future<void> showQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.listOfQuestions.length > 0) {
      question = widget.listOfQuestions[0]['question_text'].toString();
      answer = widget.listOfQuestions[0]['correct_answer'].toString();
      hint = widget.listOfQuestions[0]['doc'].toString(); //.split("\" ");
      Iterable matches = re.allMatches(hint);
      for (Match m in matches) {
        if (m.group(0)[0].toUpperCase() != m.group(0)[0]) {
          String match = m.group(0);
          splitHint.add(splitHint[splitHint.length - 1] + match);
          splitHint.removeAt(splitHint.length - 2);
        } else if(m.group(0)[0].toUpperCase() == m.group(0)[0] && m.group(0)[m.group(0).length-1] != "."){
          if(splitHint.length < 0){
            String match = m.group(0);
            splitHint.add(splitHint[splitHint.length - 1] + match);
            splitHint.removeAt(splitHint.length - 2);
          } else {
            String match = m.group(0);
            splitHint.add(match);
          }
        } else if (m.group(0)[0] == ' ') {
          String match = m.group(0);
          splitHint.add(splitHint[splitHint.length - 1] + match);
          splitHint.removeAt(splitHint.length - 2);
        } else if(m.group(0)[0] == RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')){
          String match = m.group(0);
          splitHint.add(splitHint[splitHint.length - 1] + match);
          splitHint.removeAt(splitHint.length - 2);
        } else {
          String match = m.group(0);
          splitHint.add(match);
        }
      }
      _selected = splitHint[0];
      print("HINT!!!!!!");
      print(splitHint);
      answer.toLowerCase();
      print(answer);
      questionid = widget.listOfQuestions[0]['id'].toInt();
      print('question id that we like it : $questionid');
      //_loadData();
      //lobbydatabaseHelper.addGameClaim(questionid);
    } else {
      //MP.dataQ = null;
      lobbydatabaseHelper.updateScore(score, "respondent", prefs.get('playerID'));
      canceltimer = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameFinishedManager(
            finalscore: score,
          ),
        ),
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

  void nextquestion() async{
    splitHint.clear();
    for (int i = 0; i < playerIDList.length; i++){
      await lobbydatabaseHelper.getScore("respondent", playerIDList[i]);
      if (lobbydatabaseHelper.proposerScore != null){
        scoreList.add(lobbydatabaseHelper.proposerScore);
      }
    }
    score = scoreList.fold(0, (previous, current) => previous + current);
    print(scoreList.length);
    score = (score ~/ scoreList.length);
    print("SUM SCORE");
    print(score);
    //await lobbydatabaseHelper.getScore("respondent", playerID);
    //score = lobbydatabaseHelper.proposerScore;//prefs.getInt('proposerScore');
    showQuestion();
    canceltimer = false;
    timer = 45;
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
                        child: new DropdownButton<dynamic>(
                          isDense: true,
                          value: _selected,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              _selected = newValue;
                            });
                            print(_selected);
                          },
                          items:
                          splitHint
                              .map<DropdownMenuItem<dynamic>>((dynamic value) {
                            return new DropdownMenuItem<dynamic>(
                              value: value,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                      width: 300,
                                      child: Center(
                                        child: Text(value.toString()),
                                      )),
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
                    //var dochint = ' here wwe add heint';
                    var dochint = _selected.toString();
                    print('question id appear when u press send hint');
                    print(questionid);
                    // i neeed to add to parameters questionid and selected hint
                    lobbydatabaseHelper.addGameClaim(questionid, dochint);
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
