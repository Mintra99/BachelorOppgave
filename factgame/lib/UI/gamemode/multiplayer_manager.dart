import 'package:factgame/UI/lobby/createlobby.dart';
import 'package:factgame/UI/lobby/joinlobby.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';

class MultiplayerManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Multiplayer();
  }
}

class _Multiplayer extends State<MultiplayerManager> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(10.0),
            child: Center(
              child: ButtonTheme(
                minWidth: 300.0,
                height: 75.0,
                child: RaisedButton(
                  shape: globalButtonBorder,
                  color: Colors.blue,
                  //padding: EdgeInsets.fromLTRB(125, 10, 125, 10),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MultiplayerPage()),
                    );
                  },
                  child: Text(
                    'Multiplayer',
                    style: globalTextStyle,
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

class MultiplayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multiplayer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              child: MaterialButton(
                color: Colors.indigoAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateLobby()
                    ),
                  );
                },
                child: Text("Create lobby",
                  style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Alike",
                  fontSize: 16.0,
                  )
                ),
                splashColor: Colors.indigo[700],
                highlightColor: Colors.indigo[700],
                minWidth: 200.0,
                height: 45.0,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              child: MaterialButton(
                color: Colors.indigoAccent,
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JoinLobby()
                      ),
                    );
                  },
                child: Text("Join lobby",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Alike",
                      fontSize: 16.0,
                    )
                ),
                splashColor: Colors.indigo[700],
                highlightColor: Colors.indigo[700],
                minWidth: 200.0,
                height: 45.0,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
            )
          ],
        ),
      ),
      backgroundColor: darkGrayColor,
    );
  }
}
