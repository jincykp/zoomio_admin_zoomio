import 'package:flutter/material.dart';

class ThemeColors {
  static const Color primaryColor = Color.fromARGB(255, 219, 168, 0);
  static const Color textColor = Colors.white;
  static const Color titleColor = Colors.black;
  static const Color alertColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color baseColor = Colors.blue;
}

class Textstyles {
  static const TextStyle titleText = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: ThemeColors.textColor);

  static const TextStyle titleTextSmall = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w400, color: ThemeColors.textColor);

  static const TextStyle bodytext = TextStyle(
    fontSize: 16,
    color: ThemeColors.textColor,
  );
  static const TextStyle warningText = TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 216, 30, 30),
  );

  static const TextStyle buttonText =
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600);

  static const TextStyle smallTexts =
      TextStyle(fontSize: 10, color: Colors.white);
  static const TextStyle spclTexts = TextStyle(fontSize: 12);
  static const TextStyle dataTexts =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  // static const backgroundColor successColor = Colors.green;
}
