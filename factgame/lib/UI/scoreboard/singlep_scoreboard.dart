import 'package:factgame/models/classes/player.dart';
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
  List <Player> player = [];
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
        appBar: AppBar(title: Text('Singleplyaer Scoreboard'),
            backgroundColor: darkGrayColor),
        body: StreamBuilder(
          initialData: [], // provide an initial data
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot != null) {
              if (snapshot.data.length > 0) {
                return _buildListSimple(context, snapshot.data);
              }
              else if (snapshot.data.length==0){
                return Center(child: Text('No Data'));
              }
            } else if (snapshot.hasError) {
              return Container();
            }
            return CircularProgressIndicator();
          },
        )
    );
  }

  Widget _buildScoreboardTile(BuildContext context, Player p) {
    return ListTile(
      key: Key(p.id),
      title: Scoreboard(
        username: p.username,
       // score: p.score,
      ),
    );
  }

  Widget _buildListSimple(
      BuildContext context, List<Player> player) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ReorderableListView(
        padding: EdgeInsets.only(top: 300.0),
        children:
        player.map((Player item) => _buildScoreboardTile(context, item)).toList(),
      ),
    );
  }

  //Just for testing: sets in data
  List<Player> getList() {
    for (int i = 0; i< 10; i++) {
      player.add(Player("Player " + i.toString(), 250, i.toString()));
    }
    return player;
  }

 */
}

