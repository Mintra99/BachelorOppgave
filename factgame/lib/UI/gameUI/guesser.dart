import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:factgame/Controllers/databasehelper.dart';

class ProposerManager extends StatefulWidget {
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
  String stringResponse;
  List mapResponse;
  String question;
  int i = 0;

  Map<String, Color> btncolor = {
    "True": Colors.indigoAccent,
    "Mostly true": Colors.indigoAccent,
    "Mostly false": Colors.indigoAccent,
    "False": Colors.indigoAccent,
  };

  Future fitchData() async {
    var response =
    await http.get('https://fakenews-app.com/api/game/question/');
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        shuffle();
        showQuestion();
      });
    }
  }

  answerData(String answer_text, int questionid) async {
    String myUrl = "https://fakenews-app.com/api/game/answer/?format=json";
    final response = await http.post(myUrl, body: {
      "answer_text": "$answer_text",
      "questionid": "$questionid",
    });
    var data = json.decode(response.body);
    return response;
  }

  //List shuffle(List items) {
  void shuffle(){
    var random = new Random();

    // Go through all elements.
    for (var i = mapResponse.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = mapResponse[i];
      mapResponse[i] = mapResponse[n];
      mapResponse[n] = temp;
    }
  }



  void showQuestion() {
    if (mapResponse.length > 0){
      question = mapResponse[0]['question_text'].toString();
      mapResponse.removeAt(0);
    }
  }


  @override
  void initState() {
    fitchData();
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
        percentage = timer.toDouble() / 10.0;
      });
    });
  }

  void nextquestion() {
    // increase index by 1
    showQuestion();
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

  Widget choiceButton(String k) {
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
                          Text('Score: 100'),
                          //change this line with actual score when made
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
                      child: mapResponse == null
                          ? Container()
                          : Text(
                        // follow youtube
                        '$question',
                        //mapResponse[0]['question_text'].toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Quando",
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            choiceButton('True'),
                            choiceButton('Mostly true'),
                            choiceButton('Mostly false'),
                            choiceButton('False'),
                          ],
                        ),
                      ),
                      onTap: () {},
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
                            ))),
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
          )),
    );
  }
}
