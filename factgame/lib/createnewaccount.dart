import 'package:flutter/material.dart';
class CreateNewAccount extends StatelessWidget {
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
                SizedBox( height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Firstname',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(Icons.person,size: 40,color: Colors.blue,),
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
                Padding(padding: EdgeInsets.only(top:20)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Lastname',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(Icons.person,size: 40,color: Colors.blue,),
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
                Padding(padding: EdgeInsets.only(top:20)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(Icons.email,size: 40,color: Colors.blue,),
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
                Padding(padding: EdgeInsets.only(top:20)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    prefixIcon: Icon(Icons.lock,size: 40,color: Colors.blue,),
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
                    width:500,height: 50,
                    child:RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: Colors.lightGreenAccent,
                        child: Text('Register',style: TextStyle(fontSize: 32)),onPressed: (){},
                    )),
                SizedBox( height: 20,),

                FlatButton( child: Text('Already have an account?Login', ),splashColor: Colors.lightGreenAccent,
                  onPressed: (){
                    Navigator.pushNamed(context, 'Login');
                  },
                )
              ],
            ),
          )
      ),
    );
  }}