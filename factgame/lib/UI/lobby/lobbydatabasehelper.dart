import 'package:factgame/UI/gameUI/answerModel.dart';
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
      var dataScore= data["game_id"];
      print(dataScore);
    });
  }

  addGameQuestions(String questions) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var gameId = prefs.getInt('currentGameId'); // we use it in post method
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/game/addgame_questions/";
    final response = await http.post(myUrl,
        headers: {
          'Authorization': 'Bearer $value'
        },
        body: {
          "game_id": "$gameId",
          "questions": "$questions",
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body} ');
    });
    print(gameId);
    print(questions);
  }
}
