import 'package:flutter/material.dart';
import 'package:second_try/gears/affirmationProvider.dart';

AffirmationProvider affirmationProvider =
    AffirmationProvider.withDefaultAffirmations();

class CheckIn extends StatefulWidget {
  const CheckIn({super.key});

  @override
  CheckInState createState() => CheckInState();
}

class CheckInState extends State<CheckIn> {
  final AffirmationProvider affirmationProvider =
      AffirmationProvider.withDefaultAffirmations();

  late String currentAffirmation;
  @override
  void initState() {
    super.initState();
    currentAffirmation = affirmationProvider.getAffirmation();
  }

  void _updateAffirmation() {
    setState(() {
      currentAffirmation = affirmationProvider.getAffirmation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(229, 197, 250, 1.0),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Welcome to Awesome Daily Affirmations'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(style: TextStyle(fontSize: 46.0), '🐸        🦋'),
              Text(
                currentAffirmation,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  //letterSpacing: 1.5,
                ),
              ),
              TextButton(
                onPressed: _updateAffirmation,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: Text("Renew", style: TextStyle(fontSize: 17.0)),
              ),
              const Text(style: TextStyle(fontSize: 50.0), '🦋 🌻 🦋 🌼 🪻'),
            ],
          ),
        ),
      ),
    );
  }
}
