import 'dart:convert';

import 'package:factgame/UI/gameUI/multiplayer/guesser.dart';
import 'package:factgame/UI/gameUI/multiplayer/proposer.dart';
import 'package:factgame/UI/gamemode/multiplayer_manager.dart';
import 'package:factgame/models/classes/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import 'lobbydatabasehelper.dart';

class WaitingLobby extends StatefulWidget {
  @override
  _WaitingLobbyState createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  MultiPlayer multiPlayer = new MultiPlayer();
  List mapQuestionResponse; //lobby name
  String navn;

  @override
  void initState() {
    lobbyName();
    super.initState();
  }

  // this function return the name for the game ; Lobbyname
  lobbyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      navn = prefs.getString('gameNavn'); // we are get the gameName from local storage (we already this string in lobbydatabasehelper.dart file)
    });
  }

  Future fitchQuestionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get('https://fakenews-app.com/api/game/question/');
    if (response.statusCode == 200) {
      setState(() {
        mapQuestionResponse = json.decode(response.body);
      });
    }
  }

  /*
  void assignRole() {
     if player.role == "questioner"{
        Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => ProposerManager()),
           );}
     if player.role == "respondent"{
        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuesserManagerMP()),
                );}
  }
 */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lobby',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lobby'),
        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 250, left: 12.0, right: 12.0, bottom: 12.0),
            children: <Widget>[

              Container(
                height: 50,
                child: new Text('Lobby name: ' + '$navn'),
              ),
              Container(
                height: 50,
                child: new RaisedButton(
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.getString('gameNavn');
                    prefs.getInt('gameId');
                    //databaseHelper.joinGame(prefs.getInt('gameId'), prefs.getString('gameNavn'));
                    multiPlayer.joinGame(prefs.getInt('gameId'), prefs.getString('gameNavn'));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GuesserManagerMP()),
                    );
                  },
                  color: Colors.blue,
                  child: new Text(
                    'Start game',
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: new RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new Home(),
                    ));
                  },
                  color: Colors.blue,
                  child: new Text(
                    'Leave lobby',
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
