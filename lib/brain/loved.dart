import 'package:flutter/material.dart';

class Loved {
  final Color appBarColor;
  final Color backgroundColor;
  final String topRow;
  final String bottomRow;

  const Loved({
    required this.appBarColor,
    required this.backgroundColor,
    required this.topRow,
    required this.bottomRow,
  });

  static const Loved theme = Loved(
    appBarColor: Colors.purple,
    backgroundColor: Color.fromRGBO(229, 197, 250, 1.0),
    topRow: '🐸        🦋',
    bottomRow: '🌺 🌻 🦉 🌼 🪻',
  );
}
