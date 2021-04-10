import 'dart:async';
import 'dart:math';
import 'package:factgame/UI/lobby/lobbydatabasehelper.dart';
import 'package:factgame/UI/lobby/waitinglobby.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:factgame/Controllers/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:factgame/UI/gameUI/endscreen.dart';
import 'package:url_launcher/url_launcher.dart';

class GuesserManagerMP extends StatefulWidget {
  final String title;
  final List listOfQuestions;

  GuesserManagerMP({Key key, this.title, this.listOfQuestions})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GuesserPageState();
  }
}

class _GuesserPageState extends State<GuesserManagerMP> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  LobbydatabaseHelper lobbyDataHelper = new LobbydatabaseHelper();

  MultiPlayer MP = new MultiPlayer();

  int timer = 10;
  double percentage;
  bool canceltimer = false;
  String showtimer = "10";
  String stringResponse;
  String question;
  String answer;
  int questionid;
  int score = 0;
  List source;

  List questions;

  // Used to limit amount of questions
  int cap = 10;
  int counter = 1;

  // Used to hide/show source/next question
  bool _visible = false;
  bool answered = false;
  bool isLoading = false;

  Color colortoshow = Colors.indigoAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;

  Map<String, Color> btncolor = {
    "True": Colors.indigoAccent,
    "Mostly true": Colors.indigoAccent,
    "Half true": Colors.indigoAccent,
    "Mostly false": Colors.indigoAccent,
    "False": Colors.indigoAccent,
    "Pants on Fire": Colors.indigoAccent,
  };

  Startup() async {
    questions = widget.listOfQuestions;
    setState(() {
      isLoading = true;
    });
    if (questions == null) {
      print('noooooooo');
    } else {
      showQuestion();
    }
    setState(() {
      bool isLoading = false;
    });
    /*
    if (MP.dataQ == null) {
      print('nooooooooo');
    } else {
      shuffle();
      showQuestion();
    }

     */
  }

  //TODO: make the questions available for both guesser and proposer so they get the same questions
  // widget.listOfQuestions var MP.dataQ

  void showQuestion() {
    if (counter <= questions.length) {
      print('LISTOFQUESTIONS');
      print(questions);
      question = questions[0]['fields']['question_text'].toString();
      answer = questions[0]['fields']['correct_answer'].toString();
      source = questions[0]['sources'];
      answer.toLowerCase();
      print(answer);
      counter += 1;
      print('we print the id of question');
      print(questions[0]['pk']);
      questionid = questions[0]['pk'].toInt();
      print(questionid);
      questions.removeAt(0);
    } else {
      //widget.listOfQuestions = null;
      canceltimer = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameFinishedManager()),
      );
    }
  }

  @override
  void initState() {
    print("widget.listOfQuestions!!!");
    print(widget.listOfQuestions);
    print("INITDATAQ");
    print(MP.dataQ);
    Startup();
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
          //nextquestion();
          _toggle();
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
    btncolor["True"] = Colors.indigoAccent;
    btncolor["Mostly true"] = Colors.indigoAccent;
    btncolor["Half true"] = Colors.indigoAccent;
    btncolor["Mostly false"] = Colors.indigoAccent;
    btncolor["False"] = Colors.indigoAccent;
    btncolor["Pants on Fire"] = Colors.indigoAccent;
    _visible = false;
    answered = false;
    starttimer();
  }

  void _toggle() {
    setState(() {
      _visible = true;
    });
  }

  void checkanswer(String k) async {
    lobbyDataHelper.answerMultiPlayer(k, questionid, MP.dataGame);
    k.toLowerCase();
    print(k.toLowerCase());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (answered == false) {
      if (answer == k.toLowerCase()) {
        score += 10 * (timer);
        print(score);
        prefs.setInt('guesserScore',
            score); // we set key(guesserScore) and value(score) score: is the update score for player, and we set this integer in local Storage
        print('correct');
        answered = true;
        colortoshow = right;
      } else {
        print('wrong');
        answered = true;
        colortoshow = wrong;
      }
      _toggle();
    } else {
      if (answer == k.toLowerCase()) {
        colortoshow = right;
      } else {
        colortoshow = wrong;
      }
    }
    setState(() {
      // applying the changed color to the particular button that was selected
      btncolor[k] = colortoshow;
      canceltimer = true;
    });
  }

  Widget choiceButton(String k) {
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
        color: btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 150.0,
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
                  child: questions == null
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            choiceButton('True'),
                            choiceButton('Mostly true'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            choiceButton('Half true'),
                            choiceButton('Mostly false'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            choiceButton('False'),
                            choiceButton('Pants on Fire'),
                          ],
                        ),
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
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      //TODO: show hint
                      print("hint!!!!!!!!!!!!!!!");
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var showHint = prefs.getString('gameHint');
                      if (showHint == null) {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text('Hint'),
                                content: new Text(
                                    "Proposer have not given a hint yet, try to press "
                                    "hint again later"),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text('Hint'),
                                content: new Text(showHint.toString()),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Text(
                      "Hint",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Alike",
                        fontSize: 16.0,
                      ),
                      maxLines: 1,
                    ),
                    color: Colors.indigoAccent,
                    splashColor: Colors.indigo[700],
                    highlightColor: Colors.indigo[700],
                    minWidth: 200.0,
                    height: 45.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                )
              ],
            ),
          ),
          new Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: _visible,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              //TODO: show source
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => sourcePage(
                                      listOfSource: source,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Source",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Alike",
                                fontSize: 16.0,
                              ),
                              maxLines: 1,
                            ),
                            color: Colors.indigoAccent,
                            splashColor: Colors.indigo[700],
                            highlightColor: Colors.indigo[700],
                            minWidth: 150.0,
                            height: 45.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        )),
                    Visibility(
                        visible: _visible,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              nextquestion();
                            },
                            child: Text(
                              "Next question",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Alike",
                                fontSize: 16.0,
                              ),
                              maxLines: 1,
                            ),
                            color: Colors.indigoAccent,
                            splashColor: Colors.indigo[700],
                            highlightColor: Colors.indigo[700],
                            minWidth: 150.0,
                            height: 45.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ))
                  ],
                ),
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

class sourcePage extends StatefulWidget {
  final List listOfSource;

  const sourcePage({Key key, this.listOfSource}) : super(key: key);

  @override
  _sourcePageState createState() => _sourcePageState();
}

class _sourcePageState extends State<sourcePage> {
  List<Widget> textWidgetList = List<Widget>();

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.listOfSource.length; i++) {
      String link = widget.listOfSource[i]['link'].toString();
      print(link);
      textWidgetList.add(InkWell(
        child: Text(link),
        onTap: () => launch(link),
      ));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Sources"),
          backgroundColor: darkGrayColor,
        ),
        body: Container(
            margin: EdgeInsets.all(10.0),
            child: ListView(
              children: textWidgetList,
            )));
  }
}
