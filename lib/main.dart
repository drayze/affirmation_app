import 'package:flutter/material.dart';
import 'package:second_try/Screens/check_in.dart';
import 'package:second_try/brain/settings.dart';

void main() {
  runApp(const Affirmations());
}

class Affirmations extends StatefulWidget {
  const Affirmations({super.key});

  @override
  State<Affirmations> createState() => _AffirmationsState();
}

class _AffirmationsState extends State<Affirmations> {
  Settings _currentSettings = Settings.loved;

  void updateSettings(Settings newSettings) {
    setState(() {
      _currentSettings = newSettings;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Affirmations',
      home: CheckIn(
        currentSettings: _currentSettings,
        updateSettings: updateSettings,
      ),
    );
  }
}
