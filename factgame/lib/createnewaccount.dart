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
  final TextEditingController _firstnameController = new TextEditingController();
  final TextEditingController _lastnameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  _onPressed(){
    setState(() {
      if(_emailController.text.trim().toLowerCase().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty && _usernameController.text.trim().isNotEmpty
          && _firstnameController.text.trim().isNotEmpty && _lastnameController.text.trim().isNotEmpty ){
        databaseHelper.registerData(_usernameController.text.trim(),_emailController.text.trim().toLowerCase(),

            _lastnameController.text.trim(), _firstnameController.text.trim() ,_passwordController.text.trim()).whenComplete(() {
          if (databaseHelper.Message) {
            _showDialog();
            msgStatus = 'Check email or password';
          } else {
            // Navigator.pushReplacementNamed(context, '/dashboard');
          }
        });
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
                        Text('Register', style: TextStyle(fontSize: 32),),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            filled: true,
                            fillColor: Colors.blueGrey[100],
                            prefixIcon: Icon(
                              Icons.person, size: 40, color: Colors.blue,),
                            labelText: "Username",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )
                            ),

                          ),),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _firstnameController,
                          decoration: InputDecoration(
                            hintText: 'Firstname',
                            filled: true,
                            fillColor: Colors.blueGrey[100],
                            prefixIcon: Icon(
                              Icons.person, size: 40, color: Colors.blue,),
                            labelText: "Firstname",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )
                            ),

                          ),),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        TextFormField(
                          controller: _lastnameController,
                          decoration: InputDecoration(
                            hintText: 'Lastname',
                            filled: true,
                            fillColor: Colors.blueGrey[100],
                            prefixIcon: Icon(
                              Icons.person, size: 40, color: Colors.blue,),
                            labelText: "Lastname",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )
                            ),

                          ),),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.blueGrey[100],
                            prefixIcon: Icon(
                              Icons.email, size: 40, color: Colors.blue,),
                            labelText: "Email",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )
                            ),

                          ),),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.blueGrey[100],
                            prefixIcon: Icon(
                              Icons.lock, size: 40, color: Colors.blue,),
                            labelText: "Password",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )
                            ),

                          ),),

                        SizedBox(height: 25,),
                        SizedBox(
                            width: 500, height: 50,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.lightGreenAccent,
                              child: Text(
                                  'Register', style: TextStyle(fontSize: 32)),
                              onPressed: _onPressed,
                            )),
                        SizedBox(height: 20,),

                        FlatButton(
                          child: Text('Already have an account?Login',),
                          splashColor: Colors.lightGreenAccent,
                          onPressed: () {
                            Navigator.pushNamed(context, 'Login');
                          },
                        )
                      ],
                    ),
                  )
              ),
            );
          }

  void _showDialog(){
    showDialog(
        context:context ,
        builder:(BuildContext context){
          return AlertDialog(
            title: new Text('Failed'),
            content:  new Text('Check your email or password'),
            actions: <Widget>[
              new RaisedButton(

                child: new Text(
                  'Close',
                ),

                onPressed: (){
                  Navigator.of(context).pop();
                },

              ),
            ],
          );
        }
    );
  }

}



