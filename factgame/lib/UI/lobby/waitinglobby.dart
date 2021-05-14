import 'dart:convert';
import 'dart:io';

import 'package:factgame/UI/gameUI/multiplayer/guesser.dart';
import 'package:factgame/UI/gameUI/multiplayer/proposer.dart';
import 'package:factgame/UI/gamemode/multiplayer_manager.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import 'lobbydatabasehelper.dart';

class WaitingLobby extends StatefulWidget {
  final List listOfQuestions;
  final String role;
  final String lobbyname;
  final bool existingP;
  final bool existingQ;
  final int playerID;
  final int playerNum;

  const WaitingLobby(
      {Key key,
      this.listOfQuestions,
      this.role,
      this.lobbyname,
      this.existingP,
      this.existingQ,
      this.playerID,
      this.playerNum})
      : super(key: key);

  @override
  _WaitingLobbyState createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  MultiPlayer multiPlayer = new MultiPlayer();
  List mapQuestionResponse; //lobby name
  String name;
  int missingPlayers;
  String gamename;
  int gameid;

  @override
  void initState() {
    name = databaseHelper.getName();
    if (widget.lobbyname != null) {
      name = widget.lobbyname;
    }
    ;
    print("NAME");
    print(name);
    super.initState();
  }

  _onPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("BBBBBBBBBBBBBBBBBBBBBBBBBB");
    print(widget.existingQ);
    print(widget.existingP);
    if (widget.existingQ == false) {
      _noQuestions();
    } else if (widget.existingP == true) {
      _alreadyIn();
    } else {
      if (widget.role == "proposer") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProposerManager(
              listOfQuestions: widget.listOfQuestions,
              playerNum: widget.playerNum,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GuesserManagerMP(
              listOfQuestions: widget.listOfQuestions,
              playerID: widget.playerID,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lobby',
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, left: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        },
                        splashColor: Colors.blue.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Icon(Icons.chevron_left_outlined,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      'Lobby name: ' + '$name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/images/game.png'),
                    ),
                  ),
                ),
                Text(
                  'Start your game and make your friends happy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color:
                          Theme.of(context).textSelectionColor.withOpacity(0.8),
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 40,
                ),
                FittedBox(
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Material(
                          borderRadius: BorderRadius.all(
                            Radius.circular(70.0),
                          ),
                            color: Colors.green.shade200,
                          child: InkWell(
                            onTap: () {
                              _onPressed();
                            },
                            splashColor: Colors.green.shade600,
                            borderRadius: BorderRadius.all(Radius.circular(70)),
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green.shade900, width: 1.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(70.0),
                                ),
                              ),
                              child: FittedBox(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10, right: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Start game',
                                          style: TextStyle(
                                            fontFamily: "Alike",
                                            fontSize: 16.0,
                                          ),
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.play_circle_outline_rounded,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                        Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(70.0),
                      ),
                     color: Colors.red.shade200,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Attention!'),
                                  content: Text('The lobby will be closed'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Confirm",style: TextStyle(color: Colors.red),),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Home(),
                                        ));
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        splashColor: Colors.red.shade600,
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            
                            border: Border.all(
                                color: Colors.red.shade900, width: 1.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(70.0),
                            ),
                          ),
                          child: FittedBox(
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 10, right: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Close lobby',
                                      style: TextStyle(
                                        fontFamily: "Alike",
                                        fontSize: 16.0,
                                      ),
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.remove_circle_outline,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
                //////////////////
              
              ],
            ),
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
