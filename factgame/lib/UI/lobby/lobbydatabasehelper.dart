import 'package:factgame/UI/gameUI/answerModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LobbydatabaseHelper {

  String serverUrl = "https://fakenews-app.com/api";
  var token;
  int myId;
  String myName;
  var mapResponse;
  int currentGameId;


  getData(int id , String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myId = id;
    myName = name;
    prefs.setInt('gameId',id);
    prefs.setString('gameNavn', name);
  }

  createGame(String game_name,String numPlayers) async {
    if (numPlayers.isEmpty){
      numPlayers = '2';// setting default value if user forget to set number if players
    }
    var number = int.parse(numPlayers);
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/new_game/";
    final response = await http.post(myUrl,
        headers: {
          'Authorization': 'Bearer $value'
        },
        body: {
          "game_name": "$game_name",
          "num_of_players": '$number',
        }).then((response) {
      mapResponse = json.decode(response.body);
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
    });
    print(mapResponse);
    prefs.setInt('currentGameId', mapResponse['game']['id']);
  }

  void answerMultiPlayer(String answer_text, int questionid, int game_id)async{
    answer_text = answer_text.toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0 ;
    print(game_id);
    String myUrl = "https://fakenews-app.com/api/game/answer_game/";
    http.post(myUrl,
        headers: {
          'Authorization': 'Bearer $value'
        },
        body: {
          "answer_text": "$answer_text",
          "questionid" : "$questionid",
          "game_id" : "$game_id",
        }).then((response){
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
      var data = json.decode(response.body);
    });

  }

  addGameQuestions(List questions) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var gameId = prefs.getInt('currentGameId'); // we use it in post method
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/lobby_question/";

    for (int i = 0; i< questions.length; i++) {  // we made this for loop to send question id and game id for api , because the questions is array of selceted questions
      var question_id = questions[i]['id'];
      final response = await http.post(myUrl,
          headers: {
            'Authorization': 'Bearer $value'
          },
          body: {
            "game_id": "$gameId",
            "question_id": "$question_id",
          }).then((response) {
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body} ');
      });
    }
// Todo we have to redirect user to
  }
}
