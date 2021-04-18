import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:factgame/Controllers/databasehelper.dart';
import 'package:factgame/UI/lobby/waitinglobby.dart';
import 'package:factgame/models/classes/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import 'lobbydatabasehelper.dart';
import 'package:http/http.dart' as http;

class CreateLobby extends StatefulWidget {
  @override
  _CreateLobbyState createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  DatabaseHelper dbH = new DatabaseHelper();
  final TextEditingController _gamenameController = new TextEditingController();
  final TextEditingController numOfPlayers = new TextEditingController();


  Map mapResponse;
  int id;

  List questions = [];
  List list = [];

  @override
  void initState() {
    print("INITSTATE?");
    getQuestion();
    super.initState();
  }

  Future getQuestion() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    var response = await http.get(
      'https://fakenews-app.com/api/game/question/',
      headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
    );
    var jsonData = json.decode(response.body);
    for (var u in jsonData) {
      String display = (u["question_text"]);
      Question singleQuestion = Question(display: display, value: u);
      questions.add(singleQuestion);
    }
    print("Question!!!!!!!!!!!");
    print(questions);
    await shuffle();
  }

  void shuffle() {
    var random = new Random();
    // Go through all elements.
    for (var i = questions.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);
      var temp = questions[i];
      questions[i] = questions[n];
      questions[n] = temp;
    }
  }

  setQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < 10; i++) {
      // adds 10 questions to the lobby
      list.add(questions[i].value);
    }
    list.sort((a, b) => a['id'].compareTo(b['id']));
    print("LISTID");
    for (var i = 0; i < 10; i++) {
      // adds 10 questions to the lobby
      print(list[i]['id']);
    }
    setState(() {
      // now we are sending game_name , numofplayer and  ten questions to the game
      databaseHelper.createGame(_gamenameController.text.trim(), numOfPlayers.text.trim(), list);
      prefs.setString('gameName', _gamenameController.text.trim());
    });
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
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new Home(),
              )),
            )
          ],
        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 250, left: 12.0, right: 12.0, bottom: 12.0),
            children: <Widget>[
              Container(
                height: 50,
                child: new TextField(
                  controller: numOfPlayers,
                  keyboardType: TextInputType.number,
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
                  onPressed: () async {
                    //SharedPreferences prefs = await SharedPreferences.getInstance();
                    databaseHelper.setPlayernum(int.parse(numOfPlayers.text));
                    print("NUMOFPLAYERS!!!!");
                    print(databaseHelper.getPlayerNum());
                    await setQuestions();
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WaitingLobby(
                            listOfQuestions: list,
                            role: "proposer",
                            //playerID: prefs.getInt('userID'),
                            playerID: databaseHelper.getID(),
                            lobbyname: _gamenameController.text.trim(),
                            playerNum: databaseHelper.getPlayerNum(),
                          ),
                        ),
                      );
                    }
                  },
                  color: Colors.blue,
                  child: new Text(
                    'Create Game',
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
