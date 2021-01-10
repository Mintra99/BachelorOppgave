import 'package:flutter/material.dart';

class SingleplayerManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _Singleplayer();
  }
}

class _Singleplayer extends State<SingleplayerManager> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [Container(
      margin: EdgeInsets.all(10.0),
      child: RaisedButton(
          onPressed:() {
            //TODO: make it redirect to Singleplayer here
          },
          child: Text('Singleplayer')
      ),
    ),
    ],);
  }
}