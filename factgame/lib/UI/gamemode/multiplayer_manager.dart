import 'package:factgame/UI/lobby/createlobby.dart';
import 'package:factgame/UI/lobby/joinlobby.dart';
import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MultiplayerManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Multiplayer();
  }
}

class _Multiplayer extends State<MultiplayerManager> {
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
            color: Colors.blue.shade100,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MultiplayerPage()),
                );
              },
              splashColor: Colors.blue.shade200,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade800, width: 1.5),
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
                            'Multiplayers',
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
                            Entypo.users,
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

class MultiplayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Multiplayer"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              // decoration: BoxDecoration(
              //   color: Colors.grey.shade700,
              //   borderRadius: BorderRadius.only(
              //       bottomLeft: Radius.circular(22.0),
              //       bottomRight: Radius.circular(22.0)),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
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
                        'Multiplayer',
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
                    height: 10,
                  ),
                  Text(
                    'We provide make more experience for playing game',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionColor
                            .withOpacity(0.8),
                        fontSize: 23,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            FittedBox(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(70.0),
                      ),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateLobby()),
                          );
                        },
                        splashColor: Colors.blue.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue.shade100, width: 1.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(70.0),
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
                                      'Create lobby',
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
                                      Icons.add_circle_outline_rounded,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(70.0),
                      ),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JoinLobby()),
                          );
                        },
                        splashColor: Colors.blue.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue.shade100, width: 1.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(70.0),
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
                                      'Join lobby',
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
                                      Icons.check_circle_outline_outlined,
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
          ],
        ),
      ),
      backgroundColor: darkGrayColor,
    );
  }
}
