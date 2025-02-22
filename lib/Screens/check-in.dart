import 'package:flutter/material.dart';
import 'package:affirmation_app/gears/user_profile.dart';

class Checkin extends StatefulWidget {
  const Checkin({super.key});

  @override
  _CheckinState createState() => _CheckinState();
}

class _CheckinState extends State<Checkin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Welcome to Awesome Daily Affirmations',
          ),
          backgroundColor: Colors.greenAccent,
        ),
        body: Column(
          children: [Expanded(child: UserProfile())],
        ));
  }
}
