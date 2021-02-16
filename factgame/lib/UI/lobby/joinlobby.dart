import 'package:factgame/models/global.dart';
import 'package:factgame/models/widgets/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class JoinLobby extends StatefulWidget {
  @override
  _JoinLobbyState createState() => _JoinLobbyState();
}

class _JoinLobbyState extends State<JoinLobby> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DecoratedBox(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: getList(),
          ),
        ),
        decoration: BoxDecoration(color: darkGrayColor),
      )
    );
  }
  List<Widget> getList() {
    //replace this list with a list of lobbies
    List<Lobby> list = [];
    for (int i = 0; i< 10; i++) {
      list.add(Lobby(username: "test"));
    }
    return list;
  }
}
