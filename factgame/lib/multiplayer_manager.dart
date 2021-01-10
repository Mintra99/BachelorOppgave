import 'package:flutter/material.dart';

class MultiplayerManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _Multiplayer();
  }
}

class _Multiplayer extends State<MultiplayerManager> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [Container(
      margin: EdgeInsets.all(10.0),
      child: RaisedButton(
        onPressed:() {
          //TODO: make it redirect to Multiplayer here
        },
          child: Text('Multiplayer')
      ),
    ),
    ],);
  }
}