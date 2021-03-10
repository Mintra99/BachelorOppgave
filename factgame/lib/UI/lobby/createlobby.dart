import 'package:factgame/UI/gamemode/multiplayer_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../home.dart';
import 'lobbydatabasehelper.dart';

class CreateLobby extends StatefulWidget{
  CreateLobby({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CreateLobbyState createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  final TextEditingController _gamenameController = new TextEditingController();
  List lobbyList = [];
  Map<String, List> lobby;

  TextEditingController _lobbyNameController = TextEditingController();

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

  TextEditingController _groupNameController = TextEditingController();

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
                  controller: _gamenameController,
                  decoration: InputDecoration(
                    hintText: 'Group Name',
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

                  onPressed: () {
                    databaseHelper.createGame(
                        _gamenameController.text.trim());
                    //Navigator.of(context).push(
                      //  new MaterialPageRoute(
                        //  builder: (BuildContext context) => new Home(),
                       // )
                    //);
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