import 'dart:convert';

import 'package:factgame/UI/gamemode/multiplayer_manager.dart';
import 'package:factgame/models/classes/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import 'lobbydatabasehelper.dart';

class WaitingLobby extends StatefulWidget {
  WaitingLobby({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WaitingLobbyState createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  final TextEditingController _gamenameController = new TextEditingController();
  List mapResponse; //lobby name

  TextEditingController _lobbyNameController = TextEditingController();
  TextEditingController _groupNameController = TextEditingController();

  Future fitchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response =
    await http.get('https://fakenews-app.com/api/game/question/');
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
      });
    }
  }

  /*
  List<Widget> getPlayerLobbyList() {
    List<Player> list = [];
   //return all players in the lobby
    return list;
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
          /*
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: ()=>
            )
          ],
           */
        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 250, left: 12.0, right: 12.0, bottom: 12.0),
            children: <Widget>[

              /*
              Container(
                height: 50,
                child: ListView(
                  children: getPlayerLobbyList(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),

               */
              Container(
                height: 50,
                //TODO: trenger lobby name
                child: new Text('Lobby name:'),
              ),
              Container(
                height: 50,
                child: new RaisedButton(
                  onPressed: () {
                    //TODO: if all players in the lobby have pressed this button, start the game
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
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new Home(),
                        )
                    );
                    // TODO: leave the lobby (if there are none left in the lobby, remove it)
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
