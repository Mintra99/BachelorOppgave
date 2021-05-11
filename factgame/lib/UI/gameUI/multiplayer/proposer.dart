import 'dart:async';
import 'dart:math';
import 'package:factgame/UI/gameUI/multiplayer/guesser.dart';
import 'package:factgame/UI/lobby/lobbydatabasehelper.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:factgame/Controllers/databasehelper.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:factgame/UI/gameUI/endscreen.dart';
import 'package:shimmer/shimmer.dart';

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
  int _questionNumber = 1;

  Future fitchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    playerID = prefs.getInt('playerID') + 1;
    for (int i = 1; i < widget.playerNum; i++) {
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
      //hint = widget.listOfQuestions[0]['doc'].toString(); //.split("\" ");
      splitHint = widget.listOfQuestions[0]['doc'];

      /*Iterable matches = re.allMatches(hint);
      for (Match m in matches) {
        if (m.group(0).split(" ").length <= 7) {
          continue;
        } else {
          //checks if the first word starts with uppercase
          if (m.group(0)[0].toUpperCase() != m.group(0)[0]) {
            String match = m.group(0);
            if (splitHint.length > 0) {
              splitHint.add(splitHint[splitHint.length - 1] + match);
              splitHint.removeAt(splitHint.length - 2);
            }
          }
          //checks if first word starts with uppercase and last word does not end with .
          if (m.group(0)[0].toUpperCase() == m.group(0)[0] &&
              m.group(0)[m.group(0).length - 1] != ".") {
            if (splitHint.length > 0) {
              String match = m.group(0);
              splitHint.add(splitHint[splitHint.length - 1] + match);
              splitHint.removeAt(splitHint.length - 2);
            } else {
              String match = m.group(0);
              splitHint.add(match);
            }
          }
          // checks if sentence starts with space
          if (m.group(0)[0] == ' ') {
            String match = m.group(0);
            splitHint.add(splitHint[splitHint.length - 1] + match);
            splitHint.removeAt(splitHint.length - 2);
          }
          //checks if sentence starts with number
          if (m.group(0)[0] == RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')) {
            String match = m.group(0);
            splitHint.add(splitHint[splitHint.length - 1] + match);
            splitHint.removeAt(splitHint.length - 2);
          } else {
            String match = m.group(0);
            splitHint.add(match);
          }
        }
      }

       */
      _selected = splitHint[0];
      print("HINT!!!!!!");
      print(splitHint);
      answer.toLowerCase();
      print(answer);
      questionid = widget.listOfQuestions[0]['id'].toInt();
      print('question id that we like it : $questionid');
      //_loadData();
      //lobbydatabaseHelper.addGameClaim(questionid);
      widget.listOfQuestions.removeAt(0);
    } else {
      //MP.dataQ = null;
      lobbydatabaseHelper.updateScore(
          score, "respondent", prefs.get('playerID'));
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

  void nextquestion() async {
    setState(() {
      _questionNumber++;
    });
    splitHint.clear();
    for (int i = 0; i < playerIDList.length; i++) {
      await lobbydatabaseHelper.getScore("respondent", playerIDList[i]);
      if (lobbydatabaseHelper.proposerScore != null) {
        scoreList.add(lobbydatabaseHelper.proposerScore);
      }
    }
    score = scoreList.fold(0, (previous, current) => previous + current);
    print(scoreList.length);
    if (scoreList.length > 0) {
      score = (score ~/ scoreList.length);
      print("SUM SCORE");
      print(score);
    } else {
      print("No players answered");
    }

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
      backgroundColor: Colors.blue,
      body: Container(
        // padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                      splashColor: Colors.blue.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
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
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        'Score:' + ' $score',
                        style: TextStyle(
                            color: Theme.of(context).textSelectionColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, bottom: 20),
              child: Text(
                // Shows the question to the guesser
                'Question $_questionNumber /10',
                style: TextStyle(
                  // color: Theme.of(context).textSelectionColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 25.0,
                  fontFamily: "Quando",
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        padding: EdgeInsets.all(15.0),
                        child: widget.listOfQuestions == null
                            ? Container()
                            : Text(
                                // Shows the question to the guesser
                                question == null
                                    ? 'Getting question'
                                    : '$question',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Quando",
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Row(
                                        children: [
                                          Image.network(
                                            'https://image.flaticon.com/icons/png/128/1253/1253702.png',
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('Choose hint'),
                                        ],
                                      ),
                                      content: Container(
                                        // height: 500,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: ListView.builder(
                                            itemCount: splitHint.length,
                                            itemBuilder:
                                                (BuildContext ctx, int index) {
                                              List colors = [
                                                Colors.pink.shade800,
                                                Colors.indigo.shade600,
                                                Colors.blue.shade600,
                                                Colors.pink.shade600,
                                                Colors.orange.shade600,
                                                Colors.cyan.shade600,
                                                Colors.brown.shade600,
                                              ];
                                              colors.shuffle();
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        _selected =
                                                            splitHint[index];
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      '${index + 1}- ${splitHint[index]}',
                                                      style: TextStyle(
                                                        color: colors[0],
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: "Quando",
                                                      ),
                                                    )),
                                              );
                                            }),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Shimmer.fromColors(
                              enabled: true,
                              baseColor: Colors.deepOrange[600],
                              period: Duration(seconds: 10),
                              highlightColor: Colors.red[900],
                              child: Row(
                                children: [
                                  Text(
                                    // Shows the question to the guesser
                                    'Change hint',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Quando",
                                    ),
                                  ),
                                  Icon(Feather.chevron_down)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          _selected == null ? '' : _selected,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Quando",
                          ),
                        ),
                      ),
                      // DropdownButtonHideUnderline(
                      //   child: ButtonTheme(
                      //     alignedDropdown: true,
                      //     child: new DropdownButton<dynamic>(
                      //       isDense: true,
                      //       value: _selected,
                      //       onChanged: (dynamic newValue) {
                      //         setState(() {
                      //           _selected = newValue;
                      //         });
                      //         print(_selected);
                      //       },
                      //       items: splitHint
                      //           .map<DropdownMenuItem<dynamic>>((dynamic value) {
                      //         return new DropdownMenuItem<dynamic>(
                      //             value: value,
                      //             child: Card(
                      //               child: Container(
                      //                 width: 300,
                      //                 child: Text(value.toString()),
                      //               ),
                      //             ));
                      //       }).toList(),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: Material(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            color: Colors.deepOrange.shade200,
                            child: InkWell(
                              onTap: () {
                                //var dochint = ' here wwe add heint';
                                var dochint = _selected.toString();
                                print(
                                    'question id appear when u press send hint');
                                print(questionid);
                                // i neeed to add to parameters questionid and selected hint
                                lobbydatabaseHelper.addGameClaim(
                                    questionid, dochint);
                                //lobbydatabaseHelper.addGameClaim(questionid);
                                lobbydatabaseHelper.setHint(_selected);
                              },
                              splashColor: Colors.blue.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              child: Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.orange[800], width: 1.5),
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
                                              "Send hint",
                                              style: TextStyle(
                                                  // color: Colors.white,
                                                  fontFamily: "Alike",
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w600),
                                              maxLines: 1,
                                            ),
                                            Icon(
                                              Icons.live_help,
                                              size: 22,
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
                        height: 50,
                      ),
                      Container(
                        child: CircularPercentIndicator(
                          radius: 110,
                          lineWidth: 9.0,
                          percent: timer.toDouble() / 45,
                          center: Text(
                            '$timer',
                            style: TextStyle(
                              fontSize: 16,
                              color: timer < 11 ? Colors.red : Colors.green,
                            ),
                          ),
                          progressColor: timer < 10 ? Colors.red : Colors.green,
                        ),
                      ), SizedBox(
                        height: 50,
                      ),
                      // Container(
                      //     child: LinearPercentIndicator(
                      //   //width: 100.0,
                      //   lineHeight: 8.0,
                      //   percent: timer.toDouble() / 45,
                      //   progressColor: timer < 10 ? Colors.red : Colors.green,
                      // )),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     '$timer',
                      //     style: TextStyle(
                      //       fontSize: 35,
                      //       color: timer < 11 ? Colors.red : Colors.green,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),

            /*
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
                          items: splitHint
                              .map<DropdownMenuItem<dynamic>>((dynamic value) {
                            return new DropdownMenuItem<dynamic>(
                                value: value,
                                child: Card(
                                  child: Container(
                                    width: 300,
                                    child: Center(
                                      child: Text(value.toString()),
                                    ),
                                  ),
                                )
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
              )*/
          ],
        ),
      ),
    );
  }
}
