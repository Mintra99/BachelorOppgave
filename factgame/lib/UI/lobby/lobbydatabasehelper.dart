import 'dart:io';

import 'package:factgame/UI/gameUI/answerModel.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:flutter/cupertino.dart';
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
  int playerNum;
  int currentPlayer;
  List questionList;

  Map guesserHint;
  int proposerScore;


  getGuesserHint() {
    return guesserHint;
  }

  getName() {
    return myName;
  }

  getPlayerNum() {
    return playerNum;
  }

  getCurrentPlayer() {
    return currentPlayer;
  }

  getID() {
    return myId;
  }

  setName(String name) {
    print("NAMESET!!!");
    myName = name;
  }

  setHint(String hint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myHint = hint;
    prefs.setString('gameHint', hint);
  }

  setPlayernum(int index) {
    playerNum = index;
  }


  createGame(String game_name, String numPlayers, List listOfClaims) async {
    if (numPlayers.isEmpty) {
      numPlayers =
      '2'; // setting default value if user forget to set number if players
    }
    print("numOfPlayers: " + numPlayers);
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
    // print(mapResponse['game']['current_players']);
    print("creategame MAPRESPONSE");
    currentGameId = mapResponse['game']['id'];
    prefs.setInt('playerID', mapResponse['player_game']);

    questionList = listOfClaims;
    setName(game_name);
    addGameQuestions(
        listOfClaims); // because this function make insert to all questions, we need a new function to insert only one question.

    prefs.setInt('currentGameId', mapResponse['game']['id']);
  }

  void answerMultiPlayer(String answer_text, int questionid,
      int game_id) async {
    answer_text = answer_text.toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    if (game_id == null) {
      game_id = prefs.getInt('currentGameId');
    }

    final key = 'access';
    final value = prefs.get(key) ?? 0;
    print('we are in multiplayer ansswer $game_id');
    String myUrl = "https://fakenews-app.com/api/game/answer_game/";
    http.post(myUrl, headers: {
      'Authorization': 'Bearer $value'
    }, body: {
      "answer_text": "$answer_text",
      "questionid": "$questionid",
      "game_id": "$game_id",
    }).then((response) {
      print("answerdata mapresponse");
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
      var data = json.decode(response.body);
    });
  }

  addGameQuestions(List questions) async {
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
        mapResponse = json.decode(response.body);
        print("addGameQuestions!!!!!!!!!!!!!!");
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body} ');
      });

      print('this comming from game question $mapResponse');
    }
// Todo we have to redirect user to
  }

  addGameClaim(int claimId, String docHint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var gameId = prefs.getInt('currentGameId'); // we use it in post method
    print('this is our game id : $gameId');
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/lobby_doc/$gameId/$claimId/";
    if (claimId != null) {
      final response = await http.put(myUrl, headers: {
        'Authorization': 'Bearer $value'
      }, body: {
        // "game_id": "$gameId",
        // "question_id": "$claimId",
        "doc_hint": "$docHint",
      }).then((response) {
        mapResponse = json.decode(response.body);
        print('succesful we send question id and game id');
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body} ');
      });
      print('try to bring hint : $mapResponse');
    } else {
      print('you should select Claim');
    }
  }


  getHint(int claimId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var gameId = prefs.getInt('currentGameId'); // we use it in post method
    print('gethint game id  : $gameId');
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/get_hint/$gameId/$claimId/";
    if (claimId != null) {
      final response = await http.get(myUrl, headers: {
        'Authorization': 'Bearer $value'
      }).then((response) {
        print('hint the doc from claim');
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body} ');
        guesserHint = json.decode(response.body);
      });
    } else {
      print('you should select Claim');
    }
  }

  updateScore(int score, String userStatus, int userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var gameId = prefs.getInt('currentGameId'); // we use it in post method
    print("updateScore");
    print('this is our game id : $gameId');
    print('this is our userID: $userID');
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/lobby_score/$gameId/$userStatus/$userID/";
    if (userStatus != null) {
      final response = await http.put(myUrl, headers: {
        'Authorization': 'Bearer $value'
      }, body: {
        // "game_id": "$gameId",
        // "question_id": "$claimId",
        "score": "$score",
      }).then((response) {
        print('response.body update: ' + response.body);
        mapResponse = json.decode(response.body);
        print('succesful we send question id and game id');
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body} ');
      });
      print('try to bring Updatascore : $mapResponse');
    } else {
      print('This is update score');
    }
  }
  getScore(String userStatus, int userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var gameId = prefs.getInt('currentGameId'); // we use it in post method
    print("getScore");
    print('gethint game id  : $gameId');
    print('this is our userID: $userID');
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/get_score/$gameId/$userStatus/$userID/";
    if (userStatus != null) {
      final response = await http.get(myUrl, headers: {
        'Authorization': 'Bearer $value'
      }).then((response) {
        if(response.statusCode == 500 ){
          print("ERROR");
          proposerScore = null;
        } else {
          print('get the score from gusser');
          print('Response status : ${response.statusCode}');
          print('Response status : ${response.body} ');
          Map mapResponse = json.decode(response.body);
          proposerScore = mapResponse['score'];
          prefs.setInt('proposerScore', proposerScore);
        }
      });
    } else {
      print('you should select Claim');
    }
  }
}
