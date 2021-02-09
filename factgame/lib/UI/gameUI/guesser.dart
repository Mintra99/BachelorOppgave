import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProposerManager extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProposerPageState();
  }
}

class _ProposerPageState extends State<ProposerManager> {
  int timer = 10;
  double percentage;
  bool canceltimer = false;
  String showtimer = "10";

  Map<String, Color> btncolor = {
    "True": Colors.indigoAccent,
    "Mostly true": Colors.indigoAccent,
    "Mostly false": Colors.indigoAccent,
    "False": Colors.indigoAccent,
  };

  @override
  void initState() {
    starttimer();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
        percentage = timer.toDouble()/10.0;
      });
    });
  }

  void nextquestion() {
    canceltimer = false;
    timer = 10;
    starttimer();
  }

  void checkanswer() {
    setState(() {
      // applying the changed color to the particular button that was selected
      canceltimer = true;
    });
    //adds delay so the user can see the answer
    Timer(Duration(seconds: 2), nextquestion);
  }

  Widget choicebutton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(),
        child: Text(
          k.toString(),
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //children: <Widget>[
          children: [
            new Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        BackButton(),
                        Spacer(),
                        Text('Score: 100'), //change this line with actual score when made
                      ],
                    ),
                  ),
                  /*Container(
                    height: 100,
                    child: Title(
                        color: Colors.black,
                        child: Text(
                          'Score:',
                          textAlign: TextAlign.center,
                        )),
                    width: double.infinity,
                  ),*/
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      //Swap 'hello' with questions from the database
                      'hello',
                      style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Quando",
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        choicebutton('True'),
                        choicebutton('Mostly true'),
                        choicebutton('Mostly false'),
                        choicebutton('False'),
                      ],
                    ),
                  ),

                  /*Container(
                    child: MaterialButton(
                      color: Colors.indigo,
                      child: Text('True'),
                      onPressed: (){
                        checkanswer();
                      },
                    ),
                  ),
                  Container(
                    child: MaterialButton(
                      color: Colors.indigo,
                      child: Text('Not enough info'),
                      onPressed: (){
                        checkanswer();
                      },
                    ),
                  ),
                  Container(
                    child: MaterialButton(
                      color: Colors.indigo,
                      child: Text('False'),
                      onPressed: (){
                        checkanswer();
                      },
                    ),
                  )*/
                ],
              ),
            ),
            new Container(
              child: Column(
                children: [
                  Container(
                    width: 250,
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Colors.grey,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          )
                      )
                  ),
                  Container(
                    child: Text(
                      '$timer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 48,
                      ),
                    ),
                  )
                ],

              ),
            )
          ],
        )
      ),
    );
  }
}

