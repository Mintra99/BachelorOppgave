import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';

import './scoreboard.dart';

class MPScoreboardManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoreboardManagerState();
  }
}

class _ScoreboardManagerState extends State<MPScoreboardManager> {
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
                  'Multiplayer',
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
      appBar: AppBar(title: Text('Multiplayer Scoreboard')),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return new GestureDetector(
                    onTap: () {
                      //TODO: can make this onTap navigate to their profile, else just remove the onTap
                    },
                    child: new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Container(
                        color: Colors.grey,
                        height: 100.0,
                        child: Column(
                          children: [
                            //TODO: Make Scoreboard return playername and score
                            Scoreboard(), //Returns 'Playername'
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

