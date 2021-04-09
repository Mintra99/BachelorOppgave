import 'dart:convert';
import 'dart:io';

import 'package:factgame/UI/gameUI/multiplayer/guesser.dart';
import 'package:factgame/UI/gameUI/multiplayer/proposer.dart';
import 'package:factgame/UI/gamemode/multiplayer_manager.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:factgame/models/classes/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import 'lobbydatabasehelper.dart';

class WaitingLobby extends StatefulWidget {
  final List listOfQuestions;
  final String role;

  const WaitingLobby({Key key, this.listOfQuestions, this.role}) : super(key: key);

  @override
  _WaitingLobbyState createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  MultiPlayer multiPlayer = new MultiPlayer();
  List mapQuestionResponse; //lobby name
  String navn;
  int missingPlayers;
  String gamename;
  int gameid;

  /*
  @override
  void initState() {
    //startup();
    /*print("NUMBERS!!!!!!");
    print(databaseHelper.getPlayerNum());
    print(databaseHelper.getCurrentPlayer());
    missingPlayers = databaseHelper.getPlayerNum() /*- databaseHelper.getCurrentPlayer()*/;
     */
    //lobbyName();

    sleep(const Duration(seconds: 3));
    print("INITSTATE!!!!!!?");
    print(databaseHelper.getID());
    print(databaseHelper.getName());
    //multiPlayer.joinGame(databaseHelper.getID(), databaseHelper.getName());

    super.initState();
  }

   */
/*
  Future startup() async{
    final prefs = await SharedPreferences.getInstance();
    gamename = prefs.getString('gameName');
    gameid = prefs.getInt('gameId');
    missingPlayers = prefs.getInt('playerNum') - prefs.getInt("currentPlayer");
    print("STARTUPTHING");
    //var role = prefs.getString('role');
    print("GAMENAME!!!!?");
    print(gamename);
    print("GAMEID");
    print(gameid);
    multiPlayer.joinGame(gameid, gamename);
  }

 */
/*
  // this function return the name for the game ; Lobbyname
  Future lobbyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      navn = prefs.getString('gameName');
      print("players!!!!!!!");
      print(prefs.getInt('playerNum'));
      print(prefs.getInt("currentPlayer"));
      missingPlayers = prefs.getInt('playerNum') - prefs.getInt("currentPlayer");
    });
  }

 */

  _onPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("AAAAAAAAAAAAAAAAAAAAAAAAA");
    print(multiPlayer.existingQ);
    print("BBBBBBBBBBBBBBBBBBBBBBBBBB");
    print(multiPlayer.existingP);
    if (multiPlayer.existingQ == false) {
      _noQuestions();
    } else if (multiPlayer.existingP == true) {
      _alreadyIn();
    } else  {
/*
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProposerManager(
            listOfQuestions: widget.listOfQuestions,
          ),
        ),
      );

 */
      if(widget.role == "proposer") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProposerManager(
              listOfQuestions: widget.listOfQuestions,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GuesserManagerMP(
              listOfQuestions: widget.listOfQuestions,
            ),
          ),
        );
      }
    }

      // The one above is for guesser, the one below is for proposer
      /*
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GuesserManagerMP()),
        //MaterialPageRoute(builder: (context) => ProposerManager()),
      );

       */
    }

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
                child: new Text('Lobby name: ' + databaseHelper.getName()),
              ),
              /*Container(
                height: 50,
                child: new Text('Players missing: ' + '$missingPlayers'),
              ),

               */
              Container(
                height: 50,
                child: new RaisedButton(
                  onPressed: () async {
                    _onPressed();
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
                    //TODO: remove player from the lobby
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
  void _noQuestions() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Questions are not ready'),
            content: new Text('Proposer have not added questions yet'),
            actions: <Widget>[
              new FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _alreadyIn() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Player already in'),
            content: new Text('This player is already in game'),
            actions: <Widget>[
              new FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}

