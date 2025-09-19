import 'package:flutter/material.dart';
import 'package:affirmation_app/Screens/check-in.dart';

void main() {
  runApp(const Affirmations());
}

class Affirmations extends StatelessWidget {
  const Affirmations({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Checkin(),
    );
  }
}
