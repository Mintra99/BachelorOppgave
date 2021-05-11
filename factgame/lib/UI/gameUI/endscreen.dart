import 'package:factgame/models/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../home.dart';

class GameFinishedManager extends StatefulWidget {
  final int finalscore;

  GameFinishedManager({Key key, this.finalscore})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GameFinished();
  }
}

class _GameFinished extends State<GameFinishedManager> {
  int finalScore;


  @override
  void initState() {
    fitchData();
    super.initState();
  }

  Future fitchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response =
    await http.get('https://fakenews-app.com/api/game/question/');
    print(response.statusCode);
    int err = response.statusCode;
    if (response.statusCode == err) {
      setState(() {
        finalScore = widget.finalscore;//prefs.getInt('guesserScore');// we are get the score from local storage (we already this integer in guesser.dart file)
        print("finalscore" + finalScore.toString());
        if (finalScore == null) {
          finalScore = 0;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 10.0,
                ),
              child: Text("Final Score: " + '$finalScore', style: globalTextStyle),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              child: MaterialButton(
                color: Colors.indigoAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new Home()),
                  );
                },
                child: Text("Return to main menu",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Alike",
                      fontSize: 16.0,
                    )),
                splashColor: Colors.indigo[700],
                highlightColor: Colors.indigo[700],
                minWidth: 200.0,
                height: 45.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: darkGrayColor,
    );
  }
}