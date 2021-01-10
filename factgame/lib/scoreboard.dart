import 'package:flutter/material.dart';

class Scoreboard extends StatelessWidget {
  final List<String> players;

  Scoreboard(this.players);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: players
          .map(
          (element) => Card(
            child: Column(
              children: <Widget>[
                Text(element)
                //TODO: swap out Text(element) with players later on
              ],
            ),
          ),
      ).toList(),
    );
  }
}