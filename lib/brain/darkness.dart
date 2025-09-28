import 'package:flutter/material.dart';

class Darkness {
  final Color appBarColor;
  final Color backgroundColor;
  final String topRow;
  final String bottomRow;

  const Darkness({
    required this.appBarColor,
    required this.backgroundColor,
    required this.topRow,
    required this.bottomRow,
  });

  static const Darkness theme = Darkness(
    appBarColor: Colors.black12,
    backgroundColor: Colors.lightGreenAccent,
    topRow: '💀       👻',
    bottomRow: '🦇 🩻 👽 🎃 🧟‍♂️️',
  );
}
