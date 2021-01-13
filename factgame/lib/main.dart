import 'package:flutter/material.dart';

import './scoreboard_manager.dart';
import './singleplayer_manager.dart';
import './multiplayer_manager.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fact Game'),
          leading: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.menu,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleplayerManager(), // Does nothing currently
            MultiplayerManager(), // Does nothing currently
            ScoreboardManager(), // Does nothing currently
          ],
        )
      ),
    );
  }
}