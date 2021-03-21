import 'package:factgame/UI/gameUI/multiplayer/guesser.dart';
import 'package:factgame/UI/gameUI/multiplayer/proposer.dart';
import 'package:factgame/UI/gameUI/singleplayer/guesser.dart';
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
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: MaterialButton(
                color: Colors.indigoAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => ProposerManager()),
                    MaterialPageRoute(builder: (context) => GuesserManager()),
                  );
                },
                child: Text("Start game",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Alike",
                    fontSize: 16.0,
                  )
                ),
                splashColor: Colors.indigo[700],
                highlightColor: Colors.indigo[700],
                minWidth: 200.0,
                height: 45.0,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: darkGrayColor,
    );
  }
}
