import 'package:flutter/material.dart';

Color darkGrayColor = new Color(0xFF212128);

TextStyle globalTitleStyle = new TextStyle(
    fontFamily: 'Avenir', fontWeight: FontWeight.bold, fontSize: 40);

TextStyle darkScoreboardName = new TextStyle(
  fontFamily: 'Avenir',
  fontWeight: FontWeight.bold,
  color: darkGrayColor,
  fontSize: 30,
);

TextStyle globalTextStyle = new TextStyle(
  fontFamily: 'Avenir',
  color: Colors.white,
  fontSize: 18,
);

RoundedRectangleBorder globalButtonBorder = new RoundedRectangleBorder(
  borderRadius: new BorderRadius.circular(18.0),
  side: BorderSide(color: Colors.black),
);

ButtonTheme globalButtonTheme = new ButtonTheme(
  minWidth: 200.0,
  height: 100.0,
);