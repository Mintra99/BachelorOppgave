import 'package:factgame/models/global.dart';
import 'package:flutter/material.dart';

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
        Container(
            margin: EdgeInsets.all(10.0),
            child: Center(
              child: ButtonTheme(
                minWidth: 300.0,
                height: 75.0,
                child: RaisedButton(
                  shape: globalButtonBorder,
                  color: Colors.grey,
                  //padding: EdgeInsets.fromLTRB(125, 10, 125, 10),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HowToPlayPage()),
                    );
                  },
                  child: Text(
                    'How to play',
                    style: globalTextStyle,
                  ),
                ),
              ),
            ))
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
                          border: Border.all(color: Colors.black, width: 1)),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      child: Text(
                        'The proposers job is to select a sentence form the sorce which they thingk are important for providing of disproving the claim.\n'
                            'The faster the guesser succeeds in guessing the correct label of the claim higher the score they both get.'
                      ,style: globalTextStyle),
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
                          border: Border.all(color: Colors.black, width: 1)),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      child: Text(
                          'The guesser has to guess if the claim is true or false based on the evidence chosen by the proposer.\n'
                              'The faster the guesser succeeds in guessing the correct label of the claim higher the score they both get.'
                      , style: globalTextStyle),
                    )

                  ])),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                  icon: new Icon(Icons.help_outline)
              ),
              Tab(
                  icon: new Icon(Icons.priority_high)
              )
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
