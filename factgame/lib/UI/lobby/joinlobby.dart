import 'package:factgame/Controllers/databasehelper.dart';
import 'package:factgame/UI/lobby/waitinglobby.dart';
import 'package:factgame/models/classes/multiplayerdbHelper.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  DatabaseHelper dbH = new DatabaseHelper();
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
        backgroundColor: darkGrayColor,
        appBar:
        AppBar(title: Text('Join Game'), backgroundColor: darkGrayColor),
        body: SafeArea(
          child: mapResponse == null
              ? Container()
              : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        // Divider(
                        //   thickness: 1,
                        // ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Material(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                            color: Colors.grey.shade800,
                            child: ListTile(

                              // tileColor: Colors.grey.shade800,
                                onTap: () async {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  try {
                                    await MP.joinGame(
                                        listOfGame[index]['pk'],
                                        listOfGame[index]['fields']
                                        ['game_name']);
                                    // .then((value) => showDialog(
                                    //     context: context,
                                    //     builder:
                                    //         (BuildContext context) {
                                    //       return AlertDialog(
                                    //         content:
                                    //             new Text('Joining...'),
                                    //         actions: <Widget>[],
                                    //       );
                                    //     }));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => WaitingLobby(
                                          listOfQuestions: MP.getDataQ(),
                                          lobbyname: listOfGame[index]
                                          ['fields']['game_name']
                                              .toString(),
                                          existingP: MP.getExP(),
                                          existingQ: MP.getExQ(),
                                          playerID: MP.getPlayerID(),
                                          //playerID: prefs.getInt('userID'),
                                        ),
                                      ),
                                    );
                                  } catch (error) {
                                    // Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Row(
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  child: Image.network(
                                                      'https://image.flaticon.com/icons/png/128/752/752755.png'),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                new Text('Error occured'),
                                              ],
                                            ),
                                            content: new Text(
                                                'You can\'t join games that you created it'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: new Text(
                                                  'OK',
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ],
                                          );
                                        });
                                  } finally {}
                                },
                                // contentPadding: EdgeInsets.symmetric(
                                //     horizontal: 10, vertical: 5),
                                title: Text(
                                  listOfGame[index]['fields']['game_name']
                                      .toString(),
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Icon(Icons.chevron_right_rounded,
                                    color: Colors.white),
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.indigo,
                                  child: CircleAvatar(
                                      radius: 18,
                                      child: Icon(Entypo.game_controller)),
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: listOfGame == null ? 0 : listOfGame.length,
                )
              ])),
        ));
  }
}
