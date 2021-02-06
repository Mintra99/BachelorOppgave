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
  //int _counter = 10;
  int timer = 10;
  double percentage;
  bool canceltimer = false;
  String showtimer = "10";

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
          //nextquestion();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //children: <Widget>[
          children: [
            new Container(
              child: Column(
                children: [
                  Container(
                    child: Text('hello'),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text('True'),
                      onPressed: (){
                        setState((){
                          timer = 10;
                        });
                        starttimer();
                      },
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text('not enough info'),
                      onPressed: (){
                        setState((){
                          timer = 10;
                        });
                        starttimer();
                      },
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text('False'),
                      onPressed: (){
                        setState((){
                          timer = 10;
                        });
                        starttimer();
                      },
                    ),
                  )
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

            /*(timer > 0)
                ? Text("")
                : Text(
              "DONE!",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
            Text(
              '$timer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),*/
          ],
        )
      ),
    );
  }
}

