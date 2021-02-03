import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProposerManager extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Proposer();
  }
}

class Proposer extends State<ProposerManager> {
  final isSelected = <bool>[false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text('A sentence from the source!!!'),
        ),
        Container(
          child: Center(
            child: ToggleButtons(
              color: Colors.black.withOpacity(0.60),
              selectedColor: Color(0xFF6200EE),
              selectedBorderColor: Color(0xFF6200EE),
              fillColor: Color(0xFF6200EE).withOpacity(0.08),
              splashColor: Color(0xFF6200EE).withOpacity(0.12),
              hoverColor: Color(0xFF6200EE).withOpacity(0.04),
              borderRadius: BorderRadius.circular(4.0),
              constraints: BoxConstraints(minHeight: 36.0),
              isSelected: isSelected,
              onPressed: (index) {
                // Respond to button selection
                setState(() {
                  isSelected[index] = !isSelected[index];
                });
              },
              
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('True'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Mostly True'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Half True'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Mostly False'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('False'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Pants on Fire'),
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }
}