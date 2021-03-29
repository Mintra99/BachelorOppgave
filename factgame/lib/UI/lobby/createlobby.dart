import 'package:factgame/UI/lobby/selectquestions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import 'lobbydatabasehelper.dart';


class CreateLobby extends StatefulWidget{


  @override
  _CreateLobbyState createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  final TextEditingController _gamenameController =  new TextEditingController();
  final TextEditingController numOfPlayrs = new TextEditingController();
  //List lobbyList = [];
  //Map<String, List> lobby;

/*
  void _makeLobby(BuildContext context, String lobbyName) async {
    List<String> playerList = new List(2);
    playerList.add("player");
    lobby[lobbyName] = playerList;
    lobbyList.add(lobby);
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OurAddBook(
          onGroupCreation: true,
          onError: false,
          groupName: groupName,
        ),
      ),
    );
     */
  }

 */


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Create Game',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Game'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: ()=>Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (BuildContext context) => new Home(),
                  )
              ),
            )
          ],
        ),
        body:
        Container(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 250, left: 12.0, right: 12.0, bottom: 12.0),
            children: <Widget>[
              Container(
                height: 50,
                child: new TextField(
                  controller: numOfPlayrs,
                  decoration: InputDecoration(
                    hintText: 'Number Player',
                    icon: new Icon(Icons.add),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 50,
                child: new TextField(
                  controller: _gamenameController,
                  decoration: InputDecoration(
                    hintText: 'Game Name',
                    icon: new Icon(Icons.group),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 50,
                child: new RaisedButton(

                  onPressed: () async{
                    //databaseHelper.createGetData(Game Name)
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.getString('numPlayers');
                    databaseHelper.createGame(_gamenameController.text.trim(), numOfPlayrs.text.trim());
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new SelectQuestion(),
                        )
                    );
                  },
                  color: Colors.blue,
                  child: new Text(
                    'Create Game',
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}