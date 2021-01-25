import 'package:flutter/material.dart';

import 'UI/scoreboard/multip_scoreboard.dart';
import 'UI/scoreboard/singlep_scoreboard.dart';
import 'package:factgame/gamemode/singleplayer_manager.dart';
import 'package:factgame/gamemode/multiplayer_manager.dart';
import 'package:factgame/models/global.dart';


class Home extends StatefulWidget{
  State<StatefulWidget> createState(){
    return HomeState();
  }
}
/*
void main() {
  runApp(MyApp());
}
 */
//class MyApp extends StatelessWidget {
class HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: new Scaffold(
            body: TabBarView(
              children: [
                new Container(
                    color: darkGrayColor,
                    child: Column(children: [
                      Container(
                        child: Title(
                            color: Colors.black,
                            child: Text(
                              'Game modes',
                              style: globalTitleStyle,
                              textAlign: TextAlign.center,
                            )),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),
                      ),
                      SingleplayerManager(),
                      MultiplayerManager(),
                    ])),
                new Container(
                    color: darkGrayColor,
                    child: Column(children: [
                      Container(
                        child: Title(
                            color: Colors.black,
                            child: Text(
                              'Scoreboard',
                              style: globalTitleStyle,
                              textAlign: TextAlign.center,
                            )),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),
                      ),
                      SPScoreboardManager(),
                      MPScoreboardManager(),
                    ])),
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
      ),
    );
  }
}
