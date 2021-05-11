import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:factgame/Controllers/databasehelper.dart';

class CreateNewAccount extends StatefulWidget {
  CreateNewAccount({Key key}) : super(key: key);

  @override
  CreateNewAccountState createState() => CreateNewAccountState();
}

class CreateNewAccountState extends State<CreateNewAccount> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String msgStatus = '';

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPassController =
      new TextEditingController();

  _onPressed() {
    setState(() {
      if (_emailController.text.trim().toLowerCase().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _usernameController.text.trim().isNotEmpty) {
        try {
          databaseHelper
              .registerData(
                  _usernameController.text.trim(),
                  _emailController.text.trim().toLowerCase(),
                  _passwordController.text.trim())
              .whenComplete(() {
            if (databaseHelper.Message != null) {
              _showDialog(
                  'Log in now',
                  'You can login now',
                  () => Navigator.pushReplacementNamed(context, '/Login'),
                  'Login');
              msgStatus = 'You Have Account';
            } else {
              msgStatus = 'error';
              log(msgStatus);
              _showDialog('Error occured!',
                  'username or email address is already in use please try something different or login instead',
                  () {
                Navigator.of(context).pop();
              }, 'OK');
            }
          });
        } catch (error) {
          _showDialog('Error', error.message.toString(), () {
            Navigator.of(context).pop();
          }, 'OK');
        }
      }
    });
  }

  void _showDialog(
      String title, String subtitle, Function fct, String fctTextName) async {
    await showDialog(
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
                new Text(title),
              ],
            ),
            content: new Text(subtitle),
            actions: <Widget>[
              RaisedButton(
                child: new Text(
                  fctTextName,
                ),
                onPressed: fct,
              ),
            ],
          );
        });
  }

  checkForm() {
    print("password");
    print(_passwordController.text.trim());
    setState(() {
      if (EmailValidator.validate(_emailController.text.trim()) != true) {
        _emailError();
      } else if (_usernameController.text.trim().isEmpty) {
        _emptyUsername();
      } else if (_passwordController.text.trim().length < 8) {
        _tooShortPw();
      } else if (_passwordController.text.trim() !=
          _confirmPassController.text.trim()) {
        _notMatching();
      } else {
        _onPressed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
          child: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Register',
                  style: TextStyle(fontSize: 32),
                ),
                /*SizedBox(
                  height: 20,
                ),
                 */
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                    labelText: "Username",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                        )),
                  ),
                  validator: (value) =>
                      value.trim().isEmpty ? true : 'Username is required',
                ),
                /*SizedBox(
                  height: 20,
                ),
                 */
                Padding(padding: EdgeInsets.only(top: 20)),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(
                      Icons.email,
                      size: 40,
                      color: Colors.blue,
                    ),
                    labelText: "Email",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                        )),
                  ),
                  // validator: checkEmail(),
                  validator: (value) => EmailValidator.validate(value)
                      ? null
                      : "Please enter a valid email",
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 40,
                      color: Colors.blue,
                    ),
                    labelText: "Password",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                        )),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                TextFormField(
                  controller: _confirmPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 40,
                      color: Colors.blue,
                    ),
                    labelText: "Confirm Password",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                        )),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                    width: 500,
                    height: 50,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.lightGreenAccent,
                        child: Text('Register', style: TextStyle(fontSize: 32)),
                        onPressed: () {
                          checkForm();
                          //_onPressed();
                        })),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  child: Text(
                    'Already have an account? Login',
                  ),
                  splashColor: Colors.lightGreenAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, '/Login');
                  },
                )
              ],
            ),
          )),
    );
  }

  void _emailError() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Email field is wrong'),
            content:
                new Text('Check if your email is correct/email is required'),
            actions: <Widget>[
              new FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _emptyUsername() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Username field is empty'),
            content: new Text('Username is required'),
            actions: <Widget>[
              new FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _notMatching() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Passwords not matching'),
            content: new Text('Password are not matching'),
            actions: <Widget>[
              new FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _tooShortPw() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Password is too short'),
            content: new Text('Password must be at least 8 characters'),
            actions: <Widget>[
              new FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
