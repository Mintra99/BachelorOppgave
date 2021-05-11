import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HowToPlayManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HowToPlay();
  }
}

class _HowToPlay extends State<HowToPlayManager> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Material(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            color: Colors.purple.shade100,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowToPlayPage()),
                );
              },
              splashColor: Colors.purple.shade200,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple.shade800, width: 1.5),
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
                            'How to play',
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
                            Entypo.help_with_circle,
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

class HowToPlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("How to play the game"),
          ),
          body: TabBarView(
            children: [
              new Container(
                  color: darkGrayColor,
                  child: Column(children: [
                    Container(
                      child: Title(
                          color: Colors.black,
                          child: Text(
                            'Proposer',
                            style: globalTitleStyle,
                            textAlign: TextAlign.center,
                          )),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //border: Border.all(color: Colors.black, width: 1)
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      child: Text(
                          'The proposers job is to select a sentence form the sorce which they thingk are important for providing of disproving the claim.\n'
                          'The faster the guesser succeeds in guessing the correct label of the claim higher the score they both get.',
                          style: globalTextStyle),
                    )
                  ])),
              new Container(
                  color: darkGrayColor,
                  child: Column(children: [
                    Container(
                      child: Title(
                          color: Colors.black,
                          child: Text(
                            'Guesser',
                            style: globalTitleStyle,
                            textAlign: TextAlign.center,
                          )),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //border: Border.all(color: Colors.black, width: 1)
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      child: Text(
                          'The guesser has to guess if the claim is true or false based on the evidence chosen by the proposer.\n'
                          'The faster the guesser succeeds in guessing the correct label of the claim higher the score they both get.',
                          style: globalTextStyle),
                    )
                  ])),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(icon: new Icon(Icons.help_outline)),
              Tab(icon: new Icon(Icons.priority_high))
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.purple,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
