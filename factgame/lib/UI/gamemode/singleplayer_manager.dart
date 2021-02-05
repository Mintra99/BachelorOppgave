import 'package:factgame/UI/gameUI/proposer.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';

class SingleplayerManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Singleplayer();
  }
}

class _Singleplayer extends State<SingleplayerManager> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(10.0),
            child: Center(
              child: ButtonTheme(
                minWidth: 300.0,
                height: 75.0,
                child: RaisedButton(
                  shape:globalButtonBorder,
                  color: Colors.red,
                  //padding: EdgeInsets.fromLTRB(125, 10, 125, 10),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SingleplayerPage()),
                    );
                  },
                  child: Text(
                    'Singleplayer',
                    style: globalTextStyle,
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

class SingleplayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Singleplayer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProposerManager()),
                );
              },
              child: Text("Start game"),
            ),
          ],
        ),
      ),
    );
  }
}
