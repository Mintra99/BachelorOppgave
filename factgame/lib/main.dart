import 'package:flutter/material.dart';

import 'package:factgame/scoreboard//scoreboard_manager.dart';
import 'package:factgame/gamemode/singleplayer_manager.dart';
import 'package:factgame/gamemode/multiplayer_manager.dart';
import 'package:factgame/models/global.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 4,
        child: new Scaffold(
          body: TabBarView(
            children: [
              new Container(
                color: darkGrayColor,
                child: SafeArea(
                    child: Column(children: [
                  Title(
                      color: Colors.black,
                      child: Text(
                        'Game modes',
                        style: globalTitleStyle,
                      )),
                  SingleplayerManager(),
                  MultiplayerManager(),
                ])),
              ),
              new Container(
                color: darkGrayColor,
                child: SafeArea(
                    child: Column(children: [
                  Title(
                      color: Colors.black,
                      child: Text(
                        'Scoreboard',
                        style: globalTitleStyle,
                      )),
                  ScoreboardManager(),
                ])),
              ),
              new Container(
                color: darkGrayColor,
                //TODO: add profile page
              ),
              new Container(
                color: darkGrayColor,
                //TODO: add settings page
              ),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.videogame_asset),
              ),
              Tab(
                icon: new Icon(Icons.leaderboard),
              ),
              Tab(
                icon: new Icon(Icons.perm_identity),
              ),
              Tab(
                icon: new Icon(Icons.settings),
              )
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
