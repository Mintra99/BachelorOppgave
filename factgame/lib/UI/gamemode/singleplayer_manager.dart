import 'package:factgame/UI/gameUI/multiplayer/guesser.dart';
import 'package:factgame/UI/gameUI/multiplayer/proposer.dart';
import 'package:factgame/UI/gameUI/singleplayer/guesser.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SingleplayerManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Singleplayer();
  }
}

class _Singleplayer extends State<SingleplayerManager> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Material(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            color: Colors.red.shade100,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleplayerPage()),
                );
              },
              splashColor: Colors.red.shade200,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade800, width: 1.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: FittedBox(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 10, bottom: 10, right: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Single player',
                            style: TextStyle(
                              fontFamily: "Alike",
                              fontSize: 16.0,
                            ),
                            maxLines: 1,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Entypo.user,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SingleplayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor:Color(0xff1b1b1),
      //   title: Text("Singleplayer"),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                      splashColor: Colors.blue.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        child: Icon(Icons.chevron_left_outlined,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    'Single player',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/start-game-image.png'),
                  ),
                ),
              ),
              Text(
                'Adding Fun to your life',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'We provide make more experience for playing game',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Material(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        //MaterialPageRoute(builder: (context) => ProposerManager()),
                        MaterialPageRoute(
                            builder: (context) => GuesserManager()),
                      );
                    },
                    splashColor: Colors.blue.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.blue.shade100, width: 1.5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: FittedBox(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 10, bottom: 10, right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Start game',
                                  style: TextStyle(
                                    fontFamily: "Alike",
                                    fontSize: 16.0,
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.play_circle_outline_rounded,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      backgroundColor: darkGrayColor,
    );
  }
}
