import 'dart:convert';

import 'package:factgame/UI/lobby/selectquestions.dart';
import 'package:factgame/UI/lobby/waitinglobby.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import 'lobbydatabasehelper.dart';
import 'package:http/http.dart' as http;


class CreateLobby extends StatefulWidget{


  @override
  _CreateLobbyState createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  final TextEditingController _gamenameController =  new TextEditingController();
  final TextEditingController numOfPlayrs = new TextEditingController();
  Map mapResponse;
  int id;



  Future fitchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get('https://fakenews-app.com/api/game/new_game/"');
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        id = prefs.getInt('currentGameId');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Create Game',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Game'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: ()=>Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (BuildContext context) => new Home(),
                  )
              ),
            )
          ],
        ),
        body:
        Container(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 250, left: 12.0, right: 12.0, bottom: 12.0),
            children: <Widget>[
              Container(
                height: 50,
                child: new TextField(
                  controller: numOfPlayrs,
                  decoration: InputDecoration(
                    hintText: 'Default number of players is 2',
                    icon: new Icon(Icons.add),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 50,
                child: new TextField(
                  controller: _gamenameController,
                  decoration: InputDecoration(
                    hintText: 'Game Name',
                    icon: new Icon(Icons.group),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 50,
                child: new RaisedButton(

                  onPressed: () {
                    databaseHelper.createGame(_gamenameController.text.trim(), numOfPlayrs.text.trim());
                    databaseHelper.getData(id, _gamenameController.text.trim());
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new WaitingLobby(),
                        )
                    );
                  },
                  color: Colors.blue,
                  child: new Text(
                    'Create Game',
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}