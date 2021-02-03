import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';

class MultiplayerManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Multiplayer();
  }
}

class _Multiplayer extends State<MultiplayerManager> {
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
                  shape: globalButtonBorder,
                  color: Colors.blue,
                  //padding: EdgeInsets.fromLTRB(125, 10, 125, 10),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MultiplayerPage()),
                    );
                  },
                  child: Text(
                    'Multiplayer',
                    style: globalTextStyle,
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

class MultiplayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multiplayer"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
