import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,),
            ),
            title: Text(
              'Forgot Password',),
            centerTitle: true,
          ),
          body: Column(
            children: [

              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,),
                    Container(
                      width: size.width * 0.8,
                      child: Text(
                        'Enter your email we will send instruction to reset your password',),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: 350,
                      child:  TextFormField(
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
                    ),
                    Padding(padding: EdgeInsets.only(top:20)),
                    SizedBox(
                        width:350,height: 50,
                        child:RaisedButton(
                            color: Colors.lightGreenAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Text('Send',style: TextStyle(fontSize: 32)),onPressed: (){},
                        )),
                   // RoundedButton(buttonName: 'Send')
                  ],
                ),
              )
            ],),
    );

  }
  }