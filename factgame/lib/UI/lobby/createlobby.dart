import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateLobby extends StatefulWidget{
  @override
  _CreateLobbyState createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobby> {
  /*void _makeLobby(BuildContext context, String groupName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OurAddBook(
          onGroupCreation: true,
          onError: false,
          groupName: groupName,
        ),
      ),
    );
  }*/

  TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Group Name",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Create group",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      )
    );
  }
}