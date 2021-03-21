import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:factgame/Controllers/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:factgame/UI/gameUI/endscreen.dart';

class ProposerManager extends StatefulWidget {
  ProposerManager({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ProposerPageState();
  }
}

class _ProposerPageState extends State<ProposerManager> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  int timer = 10;
  double percentage;
  bool canceltimer = false;
  String showtimer = "10";
  String stringResponse;
  List mapResponse;
  String question;
  String answer;
  int questionid;
  int score = 0;


  Future fitchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response =
    await http.get('https://fakenews-app.com/api/game/question/');
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        shuffle();
        showQuestion();
      });
    }
  }

  //TODO: make the questions available for both guesser and proposer so they get the same questions
  void shuffle() {
    var random = new Random();
    // Go through all elements.
    for (var i = mapResponse.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = mapResponse[i];
      mapResponse[i] = mapResponse[n];
      mapResponse[n] = temp;
    }
  }

  void showQuestion() {
    if (mapResponse.length > 0) {
      question = mapResponse[0]['question_text'].toString();
      answer = mapResponse[0]['correct_answer'].toString();
      answer.toLowerCase();
      print(answer);
      questionid = mapResponse[0]['id'].toInt();
    } else {
      mapResponse = null;
      canceltimer = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameFinishedManager()),
      );
    }
    mapResponse.removeAt(0);
  }

  @override
  void initState() {
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

  void checkanswer(String k) async{
    databaseHelper.answerData(k, questionid);
    k.toLowerCase();
    print(k.toLowerCase());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (answer == k.toLowerCase()) {
      score += 1;
      prefs.setInt('guesserScore', score);// we set key(guesserScore) and value(score) score: is the update score for player, and we set this integer in local Storage
      print('correct');

    } else {
      print('wrong');
      //TODO: let proposer give a hint before guesser can guess again
    }
    setState(() {
      // applying the changed color to the particular button that was selected
      canceltimer = true;
    });
    //adds delay so the user can see the answer
    Timer(Duration(seconds: 2), nextquestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Container(
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
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: mapResponse == null
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
                    InkWell(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            //TODO: list of hints the proposer can give the guesser
                          ],
                        ),
                      ),
                      onTap: () {},
                    )
                  ],
                ),
              ),
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
          )),
    );
  }
}
