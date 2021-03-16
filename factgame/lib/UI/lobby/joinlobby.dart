import 'package:factgame/models/global.dart';
import 'package:factgame/models/widgets/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../home.dart';
import 'lobbydatabasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinLobby extends StatefulWidget {
  JoinLobby({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _JoinLobbyState createState() => _JoinLobbyState();
}

class _JoinLobbyState extends State<JoinLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  final TextEditingController _gameidController = new TextEditingController();
  Map mapResponse;
  List listOfGame;

  //List list = [];

  // function api to bring the list of available game
  Future fitchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response =
        await http.get('https://fakenews-app.com/api/game/available_game/');
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        listOfGame = mapResponse['games'];
      });
    }
  }


  List<Widget> getList() {
    List<Lobby> list = [];
    for (int i = 0; i < listOfGame.length; i++) {
      list.add(
          Lobby(lobbyname: listOfGame[i]['fields']['game_name'].toString()));
    }
    return list;
  }

  @override
  void initState() {
    fitchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join Game'), backgroundColor: darkGrayColor),
      body: DecoratedBox(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: getList(),
          ),
        ),
        decoration: BoxDecoration(color: darkGrayColor),
      ),
    );
    /*
                mapResponse == null
                    ? Container()
                    : SingleChildScrollView(
                        child: Column(children: <Widget>[
                        Text(mapResponse['message'].toString()),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                                child: Column(
                                  children: getList(),
                            ));
                          },
                          itemCount:
                              listOfFacts == null ? 0 : listOfFacts.length,
                        )
                      ]))));

     */
  }
}
