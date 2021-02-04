import 'package:factgame/Login-and-register/login.dart';
import 'package:flutter/material.dart';
import '../models/global.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Logout extends StatefulWidget {
  Logout({Key key}) : super(key: key);


  @override
  LogoutState createState() => LogoutState();
}
class LogoutState extends State<Logout> {
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access';
    final value = token;
    prefs.setString(key, value);
  }

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
                  color: Colors.greenAccent,
                  //padding: EdgeInsets.fromLTRB(125, 10, 125, 10),
                  onPressed: () {
                    _save('0');
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => LogIn()),
                    );
                  },
                  child: Text(
                    'Logout',
                    style: globalTextStyle,
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

             