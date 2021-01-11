import 'package:flutter/material.dart';

import './scoreboard.dart';

class ScoreboardManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _ScoreboardManagerState();
  }
}

class _ScoreboardManagerState extends State<ScoreboardManager> {
  @override
  Widget build(BuildContext context) {
  return Column(children: [Container(
      margin: EdgeInsets.all(10.0),
      child: RaisedButton(
        onPressed:() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScoreboardPage())
          );
    //TODO: make it redirect to Scoreboard here
        },
        child: Text('Scoreboard')
      ),
    ),
  ],);
  }
}

class ScoreboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scoreboard')
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Go back!'),
        ),
      ),
    );
  }
}