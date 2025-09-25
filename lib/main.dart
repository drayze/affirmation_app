import 'package:flutter/material.dart';
import 'package:second_try/Screens/check_in.dart';

void main() {
  runApp(const Affirmations());
}

class Affirmations extends StatelessWidget {
  const Affirmations({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CheckIn(),
    );
  }
}
