import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget{
  LogIn({Key key}) : super(key: key);

  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LogIn> {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmpassword = new TextEditingController();
  GlobalKey<FormState> formstatesignin = new GlobalKey<FormState>();
  GlobalKey<FormState> formstatesignup = new GlobalKey<FormState>();

  String validglobal (String val){
    if (val.isEmpty){
      return "field cannot be empty";
    }
  }
  String validusername (String val){
    if (val.trim().isEmpty){
      return "field cannot be empty";
    }
    if (val.trim().length < 4){
      return "name can not be less than 4";
    }
    if (val.trim().length > 20){
      return "name can not be more than 20";
    }
  }
  String validpassword (String val){
    if (val.trim().isEmpty){
      return "field cannot be empty";
    }
    if (val.trim().length < 4){
      return "name can not be less than 4";
    }
    if (val.trim().length > 20){
      return "name can not be more than 20";
    }
  }
  String validemail (String val){
    if (val.trim().isEmpty){
      return "field cannot be empty";
    }
    if (val.trim().length < 4){
      return "name can not be less than 4";
    }
    if (val.trim().length > 20){
      return "name can not be more than 20";
    }
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(val)){
      return "write like example (example@gmail.com)";
    }
  }

   signin(){
     var formdata = formstatesignin.currentState;
     if (formdata.validate()){
       print('valid');
     }else{
       print('not valid');
     }
   }
   signup(){
     var formdata = formstatesignup.currentState;
     if (formdata.validate()){
       print('valid');
     }else{
       print('not valid');
     }
   }
  TapGestureRecognizer _changesign;
  bool showsignin= true;
  @override
  void initState(){
    _changesign = new TapGestureRecognizer()..onTap=(){
       setState(() {
         showsignin = !showsignin;
         print(showsignin);
       });
    };
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var mdw = MediaQuery.of(context).size.width;
    var mdh = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        Container(height: double.infinity,width: double.infinity,color: Colors.white,),
        buildPositioneTop(mdw),
        buildPositioneBottom(mdw),
        buildContaineraAvatar(mdw),
        showsignin ? buildFormBoxSignin(mdw) : buildFormBoxSignup(mdw),
        Container(margin: showsignin ? EdgeInsets.fromLTRB(130, 500, 0, 0) : EdgeInsets.fromLTRB(130, 500, 0, 0),

          child: Column(
            children: [
              showsignin ? InkWell(onTap: (){},child: Text("Forget Password?", style:TextStyle(color: Colors.blue,fontWeight: FontWeight.w800))): SizedBox(),
              SizedBox(height: 24,),
              RaisedButton(
                color: showsignin ? Colors.lightGreenAccent : Colors.cyanAccent,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 40),
                onPressed: showsignin ? signin : signup ,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [RichText(text: TextSpan(text: showsignin ? "Login" : "Sign Up",style: TextStyle(color:Colors.white,fontWeight: FontWeight.w700,),),)
                 ],),),
                  Container(child: RichText(
                     text:TextSpan( style: TextStyle(color: Colors.black, fontSize:16 ),children:[
                       TextSpan(recognizer:_changesign, text:showsignin ? 'Make Account press here' : 'Login',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w700))

                                ]


                     ) )

                  )



            ],
          ))

        ],),
    );
  }
  Positioned buildPositioneTop(double mdw){
    return Positioned(
    child: Transform.scale(
    scale:1.3,
        child:Transform.translate(
    offset:Offset(0,-mdw/1.7),
    child: Container(
    height: mdw,
    width: mdw,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(mdw),
    color: Colors.grey[800])),
    ),

    ),
    );
        }
  Positioned buildPositioneBottom(double mdw){
   return Positioned(
    top: 300,
    right: mdw/1.5,
    child: Container(
    height: mdw,
    width: mdw,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(mdw),
    color: Colors.red[800].withOpacity(0.5))));
    }
  Container buildContaineraAvatar(double mdw){
    return Container(height: mdw,child: SingleChildScrollView(
        child:Container(margin: EdgeInsets.only(top:40),
        child:Column(children: [
      Center( child: Container(margin: EdgeInsets.only(top: 30 ),
        child: Text(
          showsignin ? "Login" : 'Make Account',style: TextStyle(color:Colors.white,fontSize: 20),),)),
      Padding(padding: EdgeInsets.only(top: 20),),
      AnimatedContainer(
        duration: Duration(microseconds: 700),
        height:100,width: 100,decoration: BoxDecoration(
          color: showsignin ? Colors.yellow : Colors.cyanAccent,
          borderRadius: BorderRadius.circular(100),
          boxShadow:[
            BoxShadow(color: Colors.black,blurRadius: 10,spreadRadius: 20)
          ]
      ),
        child: Icon(Icons.person,size: 60,color: Colors.white,),
      )

    ],))));
  }
  Center buildFormBoxSignin(double mdw){
    return   Center(
      child: AnimatedContainer(
        duration: Duration(microseconds: 600),
        curve: Curves.easeOutBack,
        margin: EdgeInsets.only(top:40),
        height: 250,
        width: mdw/1.2,
        decoration:BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black,spreadRadius: 4,blurRadius: 4,offset: Offset(2,2))
            ]
        ),
        child: Form(
          autovalidate: true,
          key: formstatesignin,
          child:Container(
              margin: EdgeInsets.only(top:5),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(10, 40, 5, 0)),
                  Text(
                    " Email",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextFormFieldAll(
                      " example@gmail.com ", false, email, validemail),
                  // End Text username
                  SizedBox(
                    height: 10,
                  ),
                  // Start Text password
                  Text("كلمة المرور",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextFormFieldAll(
                       'Password', true, password ,validpassword),

              /*TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white10,
                      prefixIcon: Icon(Icons.supervisor_account,size: 40,color: Colors.blue,),
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
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white10,
                      prefixIcon: Icon(Icons.supervisor_account,size: 40,color: Colors.blue,),
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

                    ),),*/


                ],
              )),
        ),
      ),
    );
  }
  Center buildFormBoxSignup(double mdw){
    return   Center(
      child: Container(
        margin: EdgeInsets.only(top:55),
        height: showsignin ? 250 : 300,
        width: mdw/1.2,
        decoration:BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black,spreadRadius: 4,blurRadius: 4,offset: Offset(2,2))
            ]
        ),
        child: Form(
          key: formstatesignup,
          child:Container(
              margin: EdgeInsets.only(top:5),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Padding(padding: EdgeInsets.fromLTRB(10, 40, 5, 0)),
                  Text(
                    "Username",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextFormFieldAll(
                      " Username ", false, username, validusername),
                  // End Text username
                  SizedBox(
                    height: 10,
                  ),
                  // Start Text password
                  Text(" Password",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextFormFieldAll(
                      "  Password", true, password, validpassword),
                  // Start Text password CONFIRM
                 /*Text("confirm password ",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextFormFieldAll("confirm password", true,
                      confirmpassword, "confirmpassword"),*/
                  // Start Text EMAIL
                  Text(" Email",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextFormFieldAll("example@gmail.com", false,
                      email, validemail),
                 /* TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                      filled: true,
                      fillColor: Colors.white10,
                      prefixIcon: Icon(Icons.supervisor_account,size: 40,color: Colors.blue,),
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
                  Padding(padding: EdgeInsets.only(top:20)),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white10,
                      prefixIcon: Icon(Icons.supervisor_account,size: 40,color: Colors.blue,),
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
                  Padding(padding: EdgeInsets.only(top:20)),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white10,
                      prefixIcon: Icon(Icons.supervisor_account,size: 40,color: Colors.blue,),
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

                    ),)*/


                ],
              )),
        ),
      ),
    );
  }
  TextFormField buildTextFormFieldAll(String myhinttext, bool pass,
      TextEditingController myController, myvalid) {
    return TextFormField(
      validator: myvalid,
      controller: myController,
      obscureText: pass,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          hintText: myhinttext,
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[500], style: BorderStyle.solid, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue, style: BorderStyle.solid, width: 1))),
    );
  }
}