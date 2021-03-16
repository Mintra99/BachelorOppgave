import 'package:factgame/UI/gameUI/answerModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LobbydatabaseHelper {

  String serverUrl = "https://fakenews-app.com/api";
  var errorMessage;

  var Message;

  var token;

  createGame(String game_name) async {
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
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
    });
  }
  joinGame(int game_id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    print('ssssssssssssssssssssssss');
    print(game_id);
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
      var dataScore= data["game_id"];
      print(dataScore);
    });
  }
}
