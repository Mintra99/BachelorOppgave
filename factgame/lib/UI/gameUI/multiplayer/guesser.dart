import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:factgame/UI/lobby/lobbydatabasehelper.dart';
import 'package:factgame/UI/lobby/waitinglobby.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:factgame/Controllers/databasehelper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:factgame/UI/gameUI/endscreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class GuesserManagerMP extends StatefulWidget {
  final String title;
  final List listOfQuestions;
  final int playerID;

  GuesserManagerMP({Key key, this.title, this.listOfQuestions, this.playerID})
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

  int timer = 45;
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
  int _questionNumber = 1;
  bool _isButtonDisabled;
  Color colortoshow = Colors.transparent;
  Color right = Colors.green;
  Color wrong = Colors.red;

  Map<String, Color> btncolor = {
    "True": Colors.transparent,
    "Mostly true": Colors.transparent,
    "Barely true": Colors.transparent,
    "Mostly false": Colors.transparent,
    "False": Colors.transparent,
    "Pants on Fire": Colors.transparent,
  };

  Startup() async {
    questions = widget.listOfQuestions;
    questions.sort((a, b) => a['pk'].compareTo(b['pk']));
    print("QUESTIONLISTID");
    for (int i = 0; i < questions.length; i++) {
      print(questions[i]['pk']);
    }
    setState(() {
      isLoading = true;
    });
    if (questions == null) {
      print('noooooooo');
    } else {
      showQuestion();
    }
  }

  //TODO: make the questions available for both guesser and proposer so they get the same questions
  // widget.listOfQuestions var MP.dataQ

  void showQuestion() {
    if (counter <= cap) {
      _isButtonDisabled = false;
      print('LISTOFQUESTIONS');
      print(questions);
      question = questions[0]['fields']['question_text'].toString();
      answer = questions[0]['fields']['correct_answer'].toString();
      source = questions[0]['fields']['sources'];
      print("SOURCE!!!!");
      print(source);
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
        MaterialPageRoute(
            builder: (context) => GameFinishedManager(
              finalscore: score,
            )),
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
          Timer(Duration(seconds: 2), nextquestion);
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
    setState(() {
      _questionNumber++;
    });
    showQuestion();
    canceltimer = false;
    timer = 45;
    btncolor["True"] = Colors.transparent;
    btncolor["Mostly true"] = Colors.transparent;
    btncolor["Barely true"] = Colors.transparent;
    btncolor["Mostly false"] = Colors.transparent;
    btncolor["False"] = Colors.transparent;
    btncolor["Pants on Fire"] = Colors.transparent;
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
        print("widget Player ID: " + widget.playerID.toString());
        lobbyDataHelper.updateScore(score, "respondent", widget.playerID);
        print('correct');
        AssetsAudioPlayer.playAndForget(Audio('assets/audios/correct.mp3'));
        answered = true;
        colortoshow = right;
      } else {
        print('wrong');
        answered = true;
        colortoshow = wrong;
        AssetsAudioPlayer.playAndForget(Audio('assets/audios/wrong.mp3'));
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
      _isButtonDisabled = true;
      btncolor[k] = colortoshow;
      //canceltimer = true;
    });
    //Timer(Duration(seconds: 2), nextquestion);
  }

  Widget choiceButton(String k) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: InkWell(
        onTap: () {
          // isAnswerTrue != null
          //     ? isAnswerTrue == true
          //         ? AssetsAudioPlayer.playAndForget(
          //             Audio('assets/audios/correct.mp3'))
          //         : AssetsAudioPlayer.playAndForget(
          //             Audio('assets/audios/wrong.mp3'))
          //     : print('isAnswerTrue still null');

          _isButtonDisabled ? null : checkanswer(k);
        },
        splashColor: Colors.blue.shade200,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        child: Container(
          decoration: BoxDecoration(
            color: btncolor[k],
            // isAnswerTrue != null
            //     ? isAnswerTrue == true
            //         ? Colors.green
            //         : Colors.red
            //     : Colors.transparent,
            border: Border.all(color: Colors.indigo[800], width: 1.5),
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 10, bottom: 10, right: 8),
              child: Text(
                k.toString(),
                style: TextStyle(
                  fontFamily: "Alike",
                  fontSize: 17.0,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.shade50,
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null;
                                },
                                splashColor: Colors.blue.shade200,
                                borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.chevron_left_outlined,
                                    color: Colors.indigo.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Score:' + ' $score',
                            style: TextStyle(
                                color: Theme.of(context).textSelectionColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 18),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // Shows the question to the guesser
                            'Question $_questionNumber /10',
                            style: TextStyle(
                              // color: Theme.of(context).textSelectionColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 25.0,
                              fontFamily: "Quando",
                            ),
                          ),
                          new Container(
                            child: Column(
                              children: [
                                Container(
                                  child: CircularPercentIndicator(
                                    radius: 60,
                                    lineWidth: 5.0,
                                    percent: timer.toDouble() / 45,
                                    center: Text(
                                      '$timer',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: timer < 11
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                    progressColor:
                                    timer < 10 ? Colors.red : Colors.green,
                                  ),
                                ),

                                // Container(
                                //   child: Text(
                                //     '$timer',
                                //     style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 48,
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                        ),
                        color: Colors.deepPurple.shade50,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.0),
                            child: questions == null
                                ? Container()
                                : Container(
                              padding: EdgeInsets.all(15.0),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  // Shows the question to the guesser
                                  '$question',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Quando",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _visible,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: Text(
                                "Answer: $answer",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Quando",
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  choiceButton('True'),
                                  choiceButton('Mostly true'),
                                  choiceButton('Barely true'),
                                  choiceButton('Half true'),
                                  choiceButton('Mostly false'),
                                  choiceButton('False'),
                                  choiceButton('Pants on Fire'),
                                ],
                              ),
                            ),
                            onTap: () {},
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      color: Colors.deepPurple.shade50,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Material(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                color: Colors.deepOrange.shade200,
                                child: InkWell(
                                  onTap: () async {
                                    //TODO: show hint
                                    Map showHint;
                                    await lobbyDataHelper.getHint(questionid);
                                    setState(() {
                                      print("hint!!!!!!!!!!!!!!!");
                                      showHint =
                                          lobbyDataHelper.getGuesserHint();
                                      //showHint.substring(12, showHint.length - 2);
                                      print(showHint['doc_hint']);
                                    });
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                    //var showHint = prefs.getString('gameHint');

                                    if (showHint['doc_hint'] == null) {
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
                                              content: new Text(
                                                  showHint['doc_hint']
                                                      .toString()),
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
                                  splashColor: Colors.blue.shade200,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                                  child: Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.orange[800],
                                          width: 1.5),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    child: FittedBox(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Shimmer.fromColors(
                                            enabled: true,
                                            baseColor: Colors.deepOrange[600],
                                            period: Duration(seconds: 10),
                                            highlightColor: Colors.red[900],
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Hint",
                                                  style: TextStyle(
                                                    // color: Colors.white,
                                                      fontFamily: "Alike",
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                  maxLines: 1,
                                                ),
                                                Icon(
                                                  Icons.live_help,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                              color: Colors.deepPurple.shade500,
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Visibility(
                                    visible: _visible,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      child: Material(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(70.0),
                                        ),
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () {
                                            print("Source!!!!!!!!!!!2222");
                                            print(source);
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
                                          splashColor: Colors.blue.shade200,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(70)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.indigo[800],
                                                  width: 1.5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(70.0),
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Source',
                                                      style: TextStyle(
                                                        fontFamily: "Alike",
                                                        fontSize: 16.0,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Icon(
                                                      Icons.arrow_circle_down,
                                                      size: 18,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
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
