import 'package:flutter/material.dart';

import '../global.dart';

class Lobby extends StatelessWidget {
  final String lobbyname;

  Lobby({this.lobbyname});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      height: 100,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10.0,
            )
          ]),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              lobbyname,
              style: darkScoreboardName,
            ),
          ),
          Spacer(),
          Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {
                  //TODO: make the button add the player to the lobby
                },
                child: Text('Join'),
              )),
        ],
      ),
    );
  }
}
