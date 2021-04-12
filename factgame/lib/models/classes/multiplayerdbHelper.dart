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
  var mapResponse;
  var noQuestions;
  var playerIn;
  bool existingQ;
  bool existingP;
  List premierKey;
  int pk;

  getExQ(){
    return existingQ;
  }

  getExP(){
    return existingP;
  }

  getDataQ(){
    return dataQ;
  }

  setExQ(bool exq){
    existingQ = exq;
  }

  setExP(bool exq){
    existingP = exq;
  }

  setDataQ(List list){
    dataQ = list;
  }

  joinGame(int game_id, String game_name) async {
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
    mapResponse = json.decode(response.body);
    premierKey = mapResponse['question_set'];
    print('i hope this have pk : $premierKey');
    print("JOINGAMESTATUS");
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body} ');

    noQuestions = response.body.contains('restult');
    playerIn = response.body.contains('user already joined the game');

    var data = json.decode(response.body);

    print("DATA!!!");
    print(data);
    //dataQ = data['question_set'];
    //dataGame= data['player']['game_id'];
    print('222222222222222222222222222223333333333');
    print(noQuestions);
    print(playerIn);
    if (noQuestions) {
      print("existingQ is false");
      setExQ(false);
      print('game has no questions: $data');

    } else if (playerIn) {
      print("existingP is true");
      setExP(true);
      print('Player already joined the game: $data');

    } else {
      setExP(false);
      setExQ(true);
      print("everything is fine");
      setDataQ(data['question_set']);
      print("DATAQ!!!!!");
      print(getDataQ());
      dataGame = data['player']['game_id'];
      print('game is ok and you join the game: ${data['message']}');

    }
  }
}