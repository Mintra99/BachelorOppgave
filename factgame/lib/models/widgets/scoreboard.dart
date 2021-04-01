import 'package:flutter/material.dart';

import '../global.dart';

class Scoreboard extends StatelessWidget {
  final String username;
  final String id;
  final int score;

  Scoreboard({this.username, this.score, this.id});

  //Scoreboard({this.username, this.id});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      height: 100,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10.0,
            )
          ]),
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0)),
          Text(
            username,
            style: darkScoreboardName,
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 175, 0)),
          Text(
            score.toString(),
            style: darkScoreboardName,
          )
        ],
      ),
    );
  }
}
