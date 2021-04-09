import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:factgame/UI/lobby/lobbydatabasehelper.dart';
import 'package:factgame/UI/lobby/waitinglobby.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:factgame/Controllers/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MultiPlayer {
  List dataQ; // list of data with both questions and answers
  int dataGame;

  var noQuestions;
  var playerIn;
  bool existingQ;
  bool existingP;

  var msg;

  void joinGame(int game_id, String game_name) async {
    print("JOINGAME");
    print(game_id);
    print(game_name);
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "https://fakenews-app.com/api/game/join_game/";
    final response = await http.post(myUrl, headers: {
      'Authorization': 'Bearer $value'
    }, body: {
      "game_id": '$game_id',
    });
    print("JOINGAMESTATUS");
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body} ');

    noQuestions = response.body.contains('restult');
    playerIn = response.body.contains('user already joined the game');

    var data = json.decode(response.body);

    print("DATA!!!");
    print(data['question_set']);
    //dataQ = data['question_set'];
    //dataGame= data['player']['game_id'];
    print('222222222222222222222222222223333333333');
    print(noQuestions);
    print(playerIn);
    if (noQuestions) {
      print("existingQ is false");
      existingQ = false;
      print('game has no questions: $data');
    } else if (playerIn) {
      print("existingP is true");
      existingP = true;
      dataQ = data['question_set'];
      dataGame = game_id;
      //dataGame = data['player']['game_id'];
      print('Player already joined the game: $data');
    } else {
      existingP = false;
      existingQ = true;
      print("everything is fine");
      dataQ = data['question_set'];
      dataGame = data['player']['game_id'];
      print('game is ok and you join the game: ${data['message']}');
    }
    /* status = response.body.contains('You can not join the game because there are no questions');
    var data = json.decode(response.body);
    dataQ = data['question_set'];
    dataGame= data['player']['game_id'];
    print(status);
    if(status){
      print('game has no questions: $data');
    }else{
      print('game is ok: ${data['message']}');
    }
  }
  }*/
  }
}