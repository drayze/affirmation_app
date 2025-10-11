import 'package:flutter/material.dart';
//A class containing settings themes for the user to choose from

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

  //Themes
  // loved theme, Summer of the 4 settings
  static const Settings loved = Settings(
    id: 'loved',
    appBarColor: Colors.purple,
    backgroundColor: Color.fromRGBO(229, 197, 250, 1.0),
    topRow: '🐸        🦋',
    bottomRow: '🌺 🌻 🦉 🌼 🪻',
  );

  // darkness theme, Autumn of the 4 settings
  static const Settings darkness = Settings(
    id: 'darkness',
    appBarColor: Colors.black,
    backgroundColor: Colors.orangeAccent,
    topRow: '💀       👻',
    bottomRow: '🦇 ☠️ 👽 🎃 🧟‍♂️️',
  );

  // kindness theme, Winter of the 4 settings
  static const Settings kindness = Settings(
    id: 'kindness',
    appBarColor: Colors.brown,
    backgroundColor: Colors.white70,
    topRow: '😻       😽',
    bottomRow: '🐻 🐺 🐶 🦝 🐻‍❄️',
  );

  // inspired theme, Spring of the 4 settings
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
