import 'package:factgame/models/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:factgame/models/widgets/scoreboard.dart';

class SPScoreboardManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoreboardManagerState();
  }
}

class _ScoreboardManagerState extends State<SPScoreboardManager> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(10.0),
            child: Center(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black),
                ),
                padding: EdgeInsets.fromLTRB(125, 10, 125, 10),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScoreboardPage()),
                  );
                },
                child: Text(
                  'Singleplayer',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ))
      ],
    );
  }
}

class ScoreboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Singleplyaer Scoreboard'),
          backgroundColor: darkGrayColor),
      body: DecoratedBox(
        child: ListView(
          children: getList(),
        ),
        decoration: BoxDecoration(color: darkGrayColor),
      ),
    );
  }

  List<Widget> getList() {
    List<Scoreboard> list = [];
    for (int i = 0; i< 10; i++) {
      list.add(Scoreboard());
    }
    return list;
  }
}

