import 'dart:io';

import 'package:factgame/UI/gameUI/answerModel.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LobbydatabaseHelper {
  MultiPlayer MP = new MultiPlayer();

  String serverUrl = "https://fakenews-app.com/api";
  var token;
  int myId;
  static String myName;
  var mapResponse;
  int currentGameId;
  String myHint;
  String myRole;
  int playerNum;
  int currentPlayer;
  List questionList;


  getName () {
    return myName;
  }
  getPlayerNum(){
    return playerNum;
  }
  getCurrentPlayer(){
    return currentPlayer;
  }
  getID(){
    return myId;
  }

  setRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myRole = role;
    prefs.setString('role', role);
  }

  setHint(String hint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myHint = hint;
    prefs.setString('gameHint', hint);
  }

  setPlayernum(int index) {
    playerNum = index;
  }

  getData(int id, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myId = id;
    myName = name;
    prefs.setInt('gameId', id);
    prefs.setString('gameName', name);
    print("GETDATA!!!");
    print(getID());
    MP.joinGame(getID(), getName());
  }

  createGame(String game_name, String numPlayers, List list) async {
    if (numPlayers.isEmpty) {
      numPlayers =
          '2'; // setting default value if user forget to set number if players
    }
    var number = int.parse(numPlayers);
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/new_game/";
    final response = await http.post(myUrl, headers: {
      'Authorization': 'Bearer $value'
    }, body: {
      "game_name": "$game_name",
      "num_of_players": '$number',
    }).then((response) {
      mapResponse = json.decode(response.body);
      print("creategame");
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
    });
    print(mapResponse);
    print("creategame MAPRESPONSE");
    currentGameId = mapResponse['game']['id'];
    print(currentGameId);

    //sleep(const Duration(seconds: 2));
    questionList = list;
    getData(currentGameId, game_name);
    addGameQuestions(list);



    //prefs.setString('lobbyName', mapResponse['game']['game_name']);
    prefs.setInt('playerNum', mapResponse['game']['num_of_players']);
    playerNum = mapResponse['game']['num_of_players'];
    prefs.setInt('currentPlayer', mapResponse['game']['current_players']);
    currentPlayer =  mapResponse['game']['current_players'];
    prefs.setInt('currentGameId', mapResponse['game']['id']);
  }

  void answerMultiPlayer(
      String answer_text, int questionid, int game_id) async {
    answer_text = answer_text.toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    print(game_id);
    String myUrl = "https://fakenews-app.com/api/game/answer_game/";
    http.post(myUrl, headers: {
      'Authorization': 'Bearer $value'
    }, body: {
      "answer_text": "$answer_text",
      "questionid": "$questionid",
      "game_id": "$game_id",
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
      var data = json.decode(response.body);
    });
  }

  addGameQuestions(List questions) async {
    //sleep(const Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var gameId = currentGameId; // we use it in post method
    print("addGameQuestionsID");
    print(gameId);
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/lobby_question/";

    for (int i = 0; i < questions.length; i++) {
      // we made this for loop to send question id and game id for api , because the questions is array of selceted questions
      var question_id = questions[i]['id'];
      final response = await http.post(myUrl, headers: {
        'Authorization': 'Bearer $value'
      }, body: {
        "game_id": "$gameId",
        "question_id": "$question_id",
      }).then((response) {
        print("addGameQuestions!!!!!!!!!!!!!!");
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body} ');
      });
    }
// Todo we have to redirect user to
  }
}
