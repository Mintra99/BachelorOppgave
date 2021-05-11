import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:factgame/Controllers/databasehelper.dart';
import 'package:factgame/UI/lobby/waitinglobby.dart';
import 'package:factgame/models/classes/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import 'lobbydatabasehelper.dart';
import 'package:http/http.dart' as http;

class CreateLobby extends StatefulWidget {
  @override
  _CreateLobbyState createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  DatabaseHelper dbH = new DatabaseHelper();
  final TextEditingController _gamenameController = new TextEditingController();
  final TextEditingController numOfPlayers = new TextEditingController();

  Map mapResponse;
  int id;

  List questions = [];
  List list = [];
  bool _isFetchingQuestions = true;
  @override
  void initState() {
    print("INITSTATE?");

    super.initState();
  }

  Future<void> getQuestion() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = prefs.get(key) ?? 0;
    var response = await http.get(
      'https://fakenews-app.com/api/game/question/',
      headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
    );
    var jsonData = json.decode(response.body);
    for (var u in jsonData) {
      String display = (u["question_text"]);
      Question singleQuestion = Question(display: display, value: u);
      questions.add(singleQuestion);
    }
    print("Question!!!!!!!!!!!");
    print(questions);
    await shuffle();
  }

  void shuffle() {
    var random = new Random();
    // Go through all elements.
    for (var i = questions.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);
      var temp = questions[i];
      questions[i] = questions[n];
      questions[n] = temp;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isFetchingQuestions
        ? getQuestion().then((value) => {
      setState(() {
        _isFetchingQuestions = false;
      }),
      print(
          'isFetchingQuestions $_isFetchingQuestions isFetchingQuestions should be false'),
    })
        : _isFetchingQuestions = false;

    print('isFetchingQuestions $_isFetchingQuestions isFetchingQuestions');
  }

  void setQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < 10; i++) {
      // list.add(questions[i].value);
      // adds 10 questions to the lobby
      if (questions.isNotEmpty) {
        print('////////////////done fetching');
        list.add(questions[i].value);
        // setState(() {
        //   isFetchingQuestions = false;
        // });
      } else {
        print('still fetching');
      }
    }
    list.sort((a, b) => a['id'].compareTo(b['id']));
    print("LISTID");
    // for (var i = 0; i < 10; i++) {
    //   // adds 10 questions to the lobby
    //   // print(list[i]['id']);
    // }
    setState(() {
      // now we are sending game_name , numofplayer and  ten questions to the game
      databaseHelper.createGame(
          _gamenameController.text.trim(), numOfPlayers.text.trim(), list);
      prefs.setString('gameName', _gamenameController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: _isFetchingQuestions
          ? Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please wait...',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontWeight: FontWeight.w800,
                fontSize: 18),
          ),
          SizedBox(
            height: 50,
          ),
          SpinKitFadingFour(
            color: Theme.of(context).textSelectionColor,
          ),
        ],
      )
          : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.98,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        },
                        splashColor: Colors.blue.shade200,
                        borderRadius:
                        BorderRadius.all(Radius.circular(12.0)),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Icon(Icons.chevron_left_outlined,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      children: [
                        Text(
                          'Create game',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new Home(),
                            ));
                          },
                          icon: Icon(
                            Feather.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Please enter the required info in order to create your game',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: numOfPlayers,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        style: TextStyle(color: Colors.blueGrey.shade100),
                        decoration: InputDecoration(
                          labelText: "Default number of players is 2",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          prefixIcon: Icon(
                            Icons.person_add,
                            color: Colors.white54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.white54,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.blueGrey.shade100),
                        controller: _gamenameController,
                        decoration: InputDecoration(
                          labelText: "Game name",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          prefixIcon: Icon(
                            Icons.gamepad,
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Material(
                          borderRadius: BorderRadius.all(
                            Radius.circular(70.0),
                          ),
                          color: Colors.green.shade100,
                          child: InkWell(
                            onTap: () async {
                              //SharedPreferences prefs = await SharedPreferences.getInstance();
                              print("BOOBA");
                              print(numOfPlayers.text.isEmpty);
                              if (numOfPlayers.text.isNotEmpty) {
                                databaseHelper.setPlayernum(
                                    int.parse(numOfPlayers.text));
                                print("NUMOFPLAYERS!!!!");
                                print(databaseHelper.getPlayerNum());
                              } else {
                                databaseHelper.setPlayernum(2);
                              }
                              setQuestions();
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WaitingLobby(
                                      listOfQuestions: list,
                                      role: "proposer",
                                      //playerID: prefs.getInt('userID'),
                                      playerID: databaseHelper.getID(),
                                      lobbyname:
                                      _gamenameController.text.trim(),
                                      playerNum:
                                      databaseHelper.getPlayerNum(),
                                    ),
                                  ),
                                );
                              }
                            },
                            splashColor: Colors.green.shade200,
                            borderRadius:
                            BorderRadius.all(Radius.circular(70)),
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green.shade800,
                                    width: 1.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(70.0),
                                ),
                              ),
                              child: FittedBox(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        top: 10,
                                        bottom: 10,
                                        right: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Create game',
                                          style: TextStyle(
                                            fontFamily: "Alike",
                                            fontSize: 16.0,
                                          ),
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons
                                              .add_circle_outline_rounded,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
