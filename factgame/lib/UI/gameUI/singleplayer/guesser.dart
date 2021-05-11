import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
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
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
  int timer = 45;
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

  List source;
  String test;
  List splitHint = [];

  // Used to hide/show source/next question
  bool _visible = false;
  bool answered = false;

  // Used to limit amount of questions
  int cap = 10;
  int counter = 1;
  bool isFetcheding = true;
  // Colors for choicebuttons
  bool _isButtonDisabled;
  Color colortoshow = Colors.transparent;
  Color right = Colors.green;
  Color wrong = Colors.red;
  //
  int _questionNumber = 1;
  bool isAnswerTrue;
  Map<String, Color> btncolor = {
    "True": Colors.transparent,
    "Mostly true": Colors.transparent,
    "Barely true": Colors.transparent,
    "Mostly false": Colors.transparent,
    "False": Colors.transparent,
    "Pants on Fire": Colors.transparent,
  };
  @override
// ignore: must_call_super
  void didChangeDependencies() {
    isFetcheding
        ? fitchData().then((value) =>
            {isFetcheding = false, print('isFetcheding22 $isFetcheding')})
        : null;
    print('isFetcheding $isFetcheding');
    super.didChangeDependencies();
  }

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
    starttimer();
  }

  void showQuestion() {
    if (counter <= cap) {
      _isButtonDisabled = false;
      //if (mapResponse.length > 0) {
      question = mapResponse[0]['question_text'].toString();
      answer = mapResponse[0]['correct_answer'].toString();
      source = mapResponse[0]['sources'];
      test = mapResponse[0]['doc'].toString();
      splitHint = mapResponse[0]['doc'];

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
        MaterialPageRoute(
            builder: (context) => GameFinishedManager(
                  finalscore: score,
                )),
      );
    }
  }

  @override
  void initState() {
    fitchData();
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
    setState(() {
      _questionNumber++;
    });
    showQuestion();
    canceltimer = false;
    timer = 45;
    btncolor["True"] = Colors.transparent;
    btncolor["Mostly true"] = Colors.transparent;
    btncolor["Barely true"] = Colors.transparent;
    btncolor["Half true"] = Colors.transparent;
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
        AssetsAudioPlayer.playAndForget(
                      Audio('assets/audios/correct.mp3'));
        setState(() {
          isAnswerTrue = true;
        });
      } else {
        print('wrong');
        answered = true;
        colortoshow = wrong;
        AssetsAudioPlayer.playAndForget(
                      Audio('assets/audios/wrong.mp3'));
        setState(() {
          isAnswerTrue = false;
        });
      }
      _toggle();
    } else {
      if (answer == k.toLowerCase()) {
        colortoshow = right;
        // AssetsAudioPlayer.playAndForget(
        //               Audio('assets/audios/correct.mp3'));
        setState(() {
          isAnswerTrue = true;
        });
      } else {
        colortoshow = wrong;
        // AssetsAudioPlayer.playAndForget(
        //               Audio('assets/audios/wrong.mp3'));
        setState(() {
          isAnswerTrue = false;
        });
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
        body: SingleChildScrollView(
      child: isFetcheding
          ? Center(
              child: Container(
                  margin: EdgeInsets.only(top: 150),
                  child: Column(
                    children: [
                      Text(
                        'Getting questions. \nPlease wait',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).textSelectionColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SpinKitFadingFour(
                        color: Theme.of(context).textSelectionColor,
                      ),
                    ],
                  )))
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
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
                      Container(
                        padding: EdgeInsets.all(15.0),
                        child: mapResponse == null
                            ? Container()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            progressColor: timer < 10
                                                ? Colors.red
                                                : Colors.green,
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
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Divider(
                      //     thickness: 1,
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                          ),
                          color: Colors.deepPurple.shade50,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.all(15.0),
                              child: mapResponse == null
                                  ? Container()
                                  : Padding(
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
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                    fontFamily: "Quando",
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                // height: 300,
                                child: Column(
                                  children: <Widget>[
                                    choiceButton('True'),
                                    choiceButton('Mostly true'),
                                    choiceButton('Barely true'),
                                    choiceButton('Half true'),
                                    choiceButton('Mostly false'),
                                    choiceButton('False'),
                                    choiceButton('Pants on Fire'),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     choiceButton('True'),
                                    //     // choiceButton('Mostly true'),
                                    //   ],
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     choiceButton('Barely true'),
                                    //     choiceButton('Mostly false'),
                                    //   ],
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     choiceButton('False'),
                                    //     choiceButton('Pants on Fire'),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
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
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
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
                              height: 15,
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                  // Spacer(),
                                  Visibility(
                                    visible: _visible,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(60),
                                        color:
                                            Theme.of(context).backgroundColor,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          onTap: nextquestion,
                                          splashColor: Colors.blue.shade200,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            child: ClipOval(
                                              child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Icon(
                                                    Icons.navigate_next_rounded,
                                                    size: 25,
                                                  )),
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
                ),
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
