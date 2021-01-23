import 'package:factgame/models/classes/player.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';

import 'package:factgame/models/widgets/scoreboard.dart';

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
      appBar: AppBar(title: Text('Multiplayer Scoreboard'),
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
      list.add(Scoreboard(username: "test"));
    }
    return list;
  }


//Everything below does not work/not finished
/*
class ScoreboardPage extends StatelessWidget {
  List <Player> player = [];
  @override
  Widget build(BuildContext context) {
    player = getList();
    return Scaffold(
      appBar: AppBar(title: Text('Multiplayer Scoreboard'),
          backgroundColor: darkGrayColor),
    );
  }

  Widget _buildScoreboardTile(BuildContext context, Player player) {
    return ListTile(
      key: Key(player.id),
      title: Scoreboard(
        username: player.username,
        score: player.score,
      ),
    );
  }



  List<Player> getList() {
    for (int i = 0; i< 10; i++) {
      player.add(Player("Player " + i.toString(), 250, i.toString()));
    }
    return player;
  }

 */
}