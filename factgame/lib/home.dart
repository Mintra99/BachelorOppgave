import 'package:factgame/UI/howtoplay.dart';
import 'package:factgame/UI/logout.dart';
import 'package:flutter/material.dart';

import 'UI/gamemode/multiplayer_manager.dart';
import 'UI/gamemode/singleplayer_manager.dart';
import 'UI/scoreboard/multip_scoreboard.dart';
import 'UI/scoreboard/singlep_scoreboard.dart';
import 'package:factgame/models/global.dart';


class Home extends StatefulWidget{
  State<StatefulWidget> createState(){
    return HomeState();
  }
}

class HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                      Container(
                        padding: EdgeInsets.only(top: 50.0),
                          child: SingleplayerManager()
                      ),
                      Container(
                        child: MultiplayerManager()
                      ),
                      Container(
                        child: HowToPlayManager()
                      ),
                      Container(
                        child: Logout(),
                      ),


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
                      Container(
                        padding: EdgeInsets.only(top: 50.0),
                        child: SPScoreboardManager(),
                      ),
                      Container(
                        child: MPScoreboardManager(),
                      )
                    ])),
                new Container(

                    color: darkGrayColor,
                    child: Column(children: [
                      Container(
                        child: Title(
                            color: Colors.black,
                            child: Text(

                              'Profile',
                              style: globalTitleStyle,
                              textAlign: TextAlign.center,
                            )),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),
                      ),
                    ])),
                new Container(
                    color: darkGrayColor,
                    child: Column(children: [
                      Container(
                        child: Title(
                            color: Colors.black,
                            child: Text(
                              'Settings',
                              style: globalTitleStyle,
                              textAlign: TextAlign.center,
                            )),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),
                      ),
                    ])),
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
                  icon: new Icon(Icons.person),
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
