import 'package:factgame/UI/lobby/waitinglobby.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import '../../home.dart';
import 'lobbydatabasehelper.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class JoinLobby extends StatefulWidget {
  @override
  _JoinLobbyState createState() => _JoinLobbyState();
}

class _JoinLobbyState extends State<JoinLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  MultiPlayer MP = new MultiPlayer();
  Map mapResponse;
  List listOfGame;
  int gamePk;
  Map getLobbyQuestionList;

  // function api to bring the list of available game
  Future fitchData() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    var response =
        await http.get('https://fakenews-app.com/api/game/available_game/');
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        listOfGame = mapResponse['games'];
      });
    }
  }

  @override
  void initState() {
    fitchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text('Join Game'), backgroundColor: darkGrayColor),
        body: SafeArea(
          child: mapResponse == null
              ? Container()
              : SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(children: <Widget>[
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await MP.joinGame(listOfGame[index]['pk'],
                                listOfGame[index]['fields']['game_name']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WaitingLobby(
                                  listOfQuestions: MP.getDataQ(),
                                  lobbyname:  listOfGame[index]['fields']['game_name'].toString(),
                                  existingP: MP.getExP(),
                                  existingQ: MP.getExQ(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Spacer(),
                                Text(
                                  listOfGame[index]['fields']['game_name']
                                      .toString(),
                                  style: darkScoreboardName,
                                ),
                                Spacer(),
                              ],
                            ),
                            margin: EdgeInsets.all(10.0),
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 10.0,
                                  )
                                ]),
                          ),
                        );
                      },
                      itemCount: listOfGame == null ? 0 : listOfGame.length,
                    )
                  ])),
        ));
  }
}
