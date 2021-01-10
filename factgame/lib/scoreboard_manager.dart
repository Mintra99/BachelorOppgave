import 'package:flutter/material.dart';

import './scoreboard.dart';

class ScoreboardManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _ScoreboardManagerState();
  }
}

class _ScoreboardManagerState extends State<ScoreboardManager> {
  List<String> _players = ['player1'];

  @override
  Widget build(BuildContext context) {
  return Column(children: [Container(
      margin: EdgeInsets.all(10.0),
      child: RaisedButton(
        onPressed:() {
          setState(() {
            _players.add('player2');
          });
    //TODO: make it redirect to Scoreboard here
        },
        child: Text('Scoreboard')
      ),
    ),
    Scoreboard(_players)
  ],);
  }
}