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
  int timer = 10;
  double percentage;
  bool canceltimer = false;
  String showtimer = "10";
  int score = 0;

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
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

  @override
  void initState() {
    starttimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //children: <Widget>[
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
                  child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  //TODO: Send the hint/question to the guesser
                                },
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      //TODO: List of hints/questions
                                    ],
                                  ),
                                  margin: EdgeInsets.all(10.0),
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 10.0,
                                        )
                                      ]),
                                ),
                              );
                            },
                           //itemcount her
                          )
                        ],
                      )),
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
