import 'package:factgame/Login-and-register/showdata.dart';
import 'package:factgame/UI/howtoplay.dart';
import 'package:flutter/material.dart';

import 'Login-and-register/logout.dart';
import 'UI/gamemode/multiplayer_manager.dart';
import 'UI/gamemode/singleplayer_manager.dart';
import 'package:factgame/models/global.dart';

class Home extends StatefulWidget {
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //debugShowCheckedModeBanner: false,

      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: new Scaffold(
            backgroundColor: darkGrayColor,
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: 30,),
                    Text(
                      'Welcome to factgame',
                      style: TextStyle(
                          fontFamily: "Alike",
                          fontSize: 30.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/images/game.png'),
                        ),
                      ),
                    ),
                    Align(
                      //change alignment ........
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Game modes',
                          style: TextStyle(
                              fontFamily: "Alike",
                              fontSize: 30.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),  SizedBox(height: 25,),
                    Row(
                      children: [SingleplayerManager(), MultiplayerManager()],
                    ),
                    HowToPlayManager()
                  ]),
                ),


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
                      Container(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Logout(),
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
                  icon: new Icon(Icons.settings),
                )
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
