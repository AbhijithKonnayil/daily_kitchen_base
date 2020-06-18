import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DKTheme {
  static const Color green1 = Color(0xFF038C3E);
  static const Color greenLight = Color(0xFF8CBF3F);
  static const Color blue = Color(0xFF398CBF);
  static const Color orange = Color(0xFFF2811D);

  static const LinearGradient greenShade =
      LinearGradient(colors: [DKTheme.green1, DKTheme.greenLight]);

  static const LinearGradient greenShadeTlBr = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      
      colors: [DKTheme.green1, DKTheme.greenLight]);

  static LinearGradient orangeShade =
      LinearGradient(colors: [DKTheme.orange, Colors.orange]);

  static TextStyle pageTitleStyle =
      TextStyle(fontSize: 100, color: DKTheme.green1);
  static TextStyle medCapsOnStyle = TextStyle(
    fontSize: 20,
    color: DKTheme.green1,
  );
  static TextStyle appBarTitleStyle =
      TextStyle(fontSize: 20, color: Colors.white);
}
