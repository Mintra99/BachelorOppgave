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
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SingleplayerPage()),
          );},
          child: Text('Singleplayer')
      ),
    ),
    ],);
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