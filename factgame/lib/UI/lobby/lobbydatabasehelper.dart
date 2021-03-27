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

  createGame(String game_name) async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
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
        }).then((response) {
          mapResponse = json.decode(response.body);
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
    });
    print(mapResponse);
     prefs.setInt('currentGameId', mapResponse['game']['id']);
  }

  joinGame(int game_id, String game_name) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/join_game/";
    final response = await http.post(myUrl,
        headers: {
          'Authorization': 'Bearer $value'
        },
        body: {
          "game_id": '$game_id',
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
      var data = json.decode(response.body);
      var dataQuestions = data['question_set'];
      // TODO: make prefs.setString below have questions from dataQuestions[
      //prefs.setString('question', dataQuestions);
      print('questions');
      print(dataQuestions);// dataQuestions inculde all questions related to this spesific game.
      // Todo we need to load dataQuestions, we need to do the same as showQuestion() function in singleplayer/quesser.dart and instead of mapresponse we use dataQuestions.
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
// Todo we have to redirect user to guesserManager
  }

  // check if answer is correct
  void answerData(String answer_text, int questionid ) async{
    answer_text = answer_text.toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0 ;
    String myUrl = "https://fakenews-app.com/api/game/answer_single/";
    http.post(myUrl,
        headers: {
          'Authorization': 'Bearer $value'
        },
        body: {
          "answer_text": "$answer_text",
          "questionid" : "$questionid",
        }).then((response){
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
      var data = json.decode(response.body);
      var dataScore= data["score"];
      prefs.setInt('score', dataScore);
    });

  }
}
