import 'package:flutter/material.dart';

class Settings {
  final String id;
  final Color appBarColor;
  final Color backgroundColor;
  final String topRow;
  final String bottomRow;

  const Settings({
    required this.id,
    required this.appBarColor,
    required this.backgroundColor,
    required this.topRow,
    required this.bottomRow,
  });

  static const Settings loved = Settings(
    id: 'loved',
    appBarColor: Colors.purple,
    backgroundColor: Color.fromRGBO(229, 197, 250, 1.0),
    topRow: '🐸        🦋',
    bottomRow: '🌺 🌻 🦉 🌼 🪻',
  );

  static const Settings darkness = Settings(
    id: 'darkness',
    appBarColor: Colors.black,
    backgroundColor: Colors.orangeAccent,
    topRow: '💀       👻',
    bottomRow: '🦇 🩻 👽 🎃 🧟‍♂️️',
  );

  static const Settings kindness = Settings(
    id: 'kindness',
    appBarColor: Colors.brown,
    backgroundColor: Colors.white70,
    topRow: '😻       😽',
    bottomRow: '🐻 🐺 🐶 🦝 🐻‍❄️',
  );

  static const Settings inspired = Settings(
    id: 'inspired',
    appBarColor: Colors.black,
    backgroundColor: Colors.tealAccent,
    topRow: '💯       💫',
    bottomRow: '💡 🌈 🌞 🌠 🦄',
  );

  static final Map<String, Settings> allSettings = {
    loved.id: loved,
    darkness.id: darkness,
    kindness.id: kindness,
    inspired.id: inspired,
  };
}
