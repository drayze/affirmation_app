import 'package:flutter/material.dart';
import 'package:second_try/gears/affirmationProvider.dart';
import 'package:second_try/brain/settings.dart';

AffirmationProvider affirmationProvider =
    AffirmationProvider.withDefaultAffirmations();

class CheckIn extends StatefulWidget {
  final Settings currentSettings;
  final void Function(Settings) updateSettings;

  const CheckIn({
    super.key,
    required this.currentSettings,
    required this.updateSettings,
  });

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

  void _updateSettings(Settings newSettings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Settings'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text('Loved'),
                onTap: () {
                  widget.updateSettings(Settings.loved);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Darkness'),
                onTap: () {
                  widget.updateSettings(Settings.darkness);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Kindness'),
                onTap: () {
                  widget.updateSettings(Settings.kindness);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Inspired'),
                onTap: () {
                  widget.updateSettings(Settings.inspired);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.currentSettings.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Welcome to Awesome Daily Affirmations'),
        backgroundColor: widget.currentSettings.appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _updateSettings(widget.currentSettings);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.currentSettings.topRow,
                style: const TextStyle(fontSize: 46.0),
              ),
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
                  backgroundColor: widget.currentSettings.appBarColor,
                  foregroundColor: Colors.white,
                ),
                child: Text("Renew", style: TextStyle(fontSize: 17.0)),
              ),
              Text(
                widget.currentSettings.bottomRow,
                style: const TextStyle(fontSize: 50.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
