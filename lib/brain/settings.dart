import 'package:flutter/material.dart';

class Settings {
  final Color appBarColor;
  final Color backgroundColor;
  final String topRow;
  final String bottomRow;

  const Settings({
    required this.appBarColor,
    required this.backgroundColor,
    required this.topRow,
    required this.bottomRow,
  });

  static const Settings loved = Settings(
    appBarColor: Colors.purple,
    backgroundColor: Color.fromRGBO(229, 197, 250, 1.0),
    topRow: '🐸        🦋',
    bottomRow: '🌺 🌻 🦉 🌼 🪻',
  );

  static const Settings darkness = Settings(
    appBarColor: Colors.black12,
    backgroundColor: Colors.lightGreenAccent,
    topRow: '💀       👻',
    bottomRow: '🦇 🩻 👽 🎃 🧟‍♂️️',
  );

  static const Settings kindness = Settings(
    appBarColor: Colors.green,
    backgroundColor: Colors.tealAccent,
    topRow: '😻       😽',
    bottomRow: '🐻 🐺 🐶 🦝 🐻‍❄️',
  );

  static const Settings inspired = Settings(
    appBarColor: Colors.black,
    backgroundColor: Colors.tealAccent,
    topRow: '💯       💫',
    bottomRow: '💡 🌈 🌞 🌠 🦄',
  );
}
