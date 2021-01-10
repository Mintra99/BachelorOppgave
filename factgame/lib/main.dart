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
        ),
        body: Column(
          children: [
            SingleplayerManager(), // Does nothing currently
            MultiplayerManager(), // Does nothing currently
            ScoreboardManager(), //The scoreboard just adds things to a list currently
          ],
        )
      ),
    );
  }
}