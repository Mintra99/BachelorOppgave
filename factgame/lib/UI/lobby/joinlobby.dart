import 'package:factgame/models/global.dart';
import 'package:factgame/models/widgets/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../home.dart';
import 'lobbydatabasehelper.dart';

class JoinLobby extends StatefulWidget {
  JoinLobby({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _JoinLobbyState createState() => _JoinLobbyState();
}

class _JoinLobbyState extends State<JoinLobby> {
  LobbydatabaseHelper databaseHelper = new LobbydatabaseHelper();
  final TextEditingController _gameidController = new TextEditingController();
  final TextEditingController _user_status = new TextEditingController();
  final TextEditingController _userController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Join Game',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Join Game'),
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
                  controller:  _gameidController,
                  decoration: InputDecoration(
                    hintText: 'Group id',
                    icon: new Icon(Icons.group),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 50,
                child: new TextField(
                  controller:  _user_status,
                  decoration: InputDecoration(
                    hintText: 'user_status',
                    icon: new Icon(Icons.group),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 50,
                child: new TextField(
                  controller:  _userController,
                  decoration: InputDecoration(
                    hintText: 'user_id',
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
                    databaseHelper.joinGame(
                        _gameidController.text.length , _user_status.text.trim(), _userController.text.length);
                    //TODO: when pressed and finds the lobby, make it redirect to correct WaitingLobby
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new Home(),
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
