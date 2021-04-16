import 'dart:async';
import 'dart:math';
import 'package:factgame/models/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:factgame/Controllers/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:factgame/UI/gameUI/endscreen.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class GuesserManager extends StatefulWidget {
  GuesserManager({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _GuesserPageState();
  }
}

class _GuesserPageState extends State<GuesserManager> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  RegExp re = new RegExp(r"(\w|\s|,|')+[。.?!]*\s*");

  // Used to create timer
  int timer = 10;
  double percentage;
  bool canceltimer = false;
  String showtimer = "10";

  // Used to retrieve data from database
  String stringResponse;
  List mapResponse;

  // Used to show question/score and check answer
  String question;
  String answer;
  int questionid;
  int score = 0;
  int hintCounter = 0;

  List source;
  List hint;
  String test;
  List splitHint = [];

  // Used to hide/show source/next question
  bool _visible = false;
  bool answered = false;

  // Used to limit amount of questions
  int cap = 10;
  int counter = 1;

  // Colors for choicebuttons
  bool _isButtonDisabled;
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

  Future fitchData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    var response = await http.get(
      'https://fakenews-app.com/api/game/question/',
      headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
    );
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        //print("testtttt");
        //print(mapResponse[0]['doc']);
        shuffle();
        showQuestion();
      });
    }
  }

  //List shuffle(List items) {
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

  void shuffleHint() {
    var random = new Random();
    // Go through all elements.
    for (var i = splitHint.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = splitHint[i];
      splitHint[i] = splitHint[n];
      splitHint[n] = temp;
    }
  }

  void showQuestion() {
    if (counter <= cap) {
      _isButtonDisabled = false;
      //if (mapResponse.length > 0) {
      question = mapResponse[0]['question_text'].toString();
      answer = mapResponse[0]['correct_answer'].toString();
      source = mapResponse[0]['sources'];
      //hint = mapResponse[0]['doc'].split("\" ");
      test = mapResponse[0]['doc'].toString();
      Iterable matches = re.allMatches(test);
      for (Match m in matches) {
        if (m.group(0)[0].toUpperCase() != m.group(0)[0]) {
          String match = m.group(0);
          //print("EXTENDINGHINT!");
          //print(splitHint[splitHint.length - 1] + match);
          splitHint.add(splitHint[splitHint.length - 1] + match);
          splitHint.removeAt(splitHint.length - 2);
        } else if(m.group(0)[0].toUpperCase() == m.group(0)[0] && m.group(0)[m.group(0).length-1] != "."){
          if(splitHint.length < 0){
            String match = m.group(0);
            //print("EXTENDINGHINT!");
            //print(splitHint[splitHint.length - 1] + match);
            splitHint.add(splitHint[splitHint.length - 1] + match);
            splitHint.removeAt(splitHint.length - 2);
          } else {
            String match = m.group(0);
            //print("EXTENDINGHINT!");
            //print(match);
            splitHint.add(match);
          }
        } else if (m.group(0)[0] == ' ') {
          String match = m.group(0);
          //print("EXTENDINGHINT!");
          //print(splitHint[splitHint.length - 1] + match);
          splitHint.add(splitHint[splitHint.length - 1] + match);
          splitHint.removeAt(splitHint.length - 2);
        } else if(m.group(0)[0] == RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')){
          String match = m.group(0);
          //print("EXTENDINGHINT!");
          //print(splitHint[splitHint.length - 1] + match);
          splitHint.add(splitHint[splitHint.length - 1] + match);
          splitHint.removeAt(splitHint.length - 2);
        } else {
          //print(m.group(0));
          String match = m.group(0);
          splitHint.add(match);
        }
      }
      answer.toLowerCase();
      print(answer);
      counter += 1;
      questionid = mapResponse[0]['id'].toInt();
      mapResponse.removeAt(0);
    } else {
      mapResponse = null;
      canceltimer = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameFinishedManager(
          finalscore: score,
        )),
      );
    }
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
    hintCounter = 0;
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
    k.toLowerCase();
    print(k.toLowerCase());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (answered == false) {
      if (answer == k.toLowerCase()) {
        if ((100 * (timer)) - (10 * hintCounter) > 0) {
          score += (100 * (timer)) - (10 * hintCounter);
        } else {
          score += 10;
        }
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
      _isButtonDisabled = true;
      btncolor[k] = colortoshow;
      canceltimer = true;
    });
    databaseHelper.answerData(k, questionid);
  }

  Widget choiceButton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () {
          _isButtonDisabled ? null : checkanswer(k);
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
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            shuffleHint();
                            hintCounter += 1;
                            return AlertDialog(
                              title: new Text('Hint'),
                              content: new Text(splitHint[0]),
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
