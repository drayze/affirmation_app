import 'package:flutter/material.dart';
import 'package:b_kind_2_u/Screens/check_in.dart';
import 'package:b_kind_2_u/brain/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'brain/notifications.dart';
import 'dart:core';

//main function to run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  Future<void> findingCurrentLocation() async {
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  await findingCurrentLocation();
  //await _initializeTimeZone();
  //await _initializeNotifications();

  // Check sharedPreferences for saved settings and defaulted to 'loved' if empty
  final prefs = await SharedPreferences.getInstance();
  final settingsId = prefs.getString('settings') ?? Settings.loved.id;
  final initSettings = Settings.allSettings[settingsId] ?? Settings.loved;

  // initialize notifications
  final notifications = Notifications();
  await notifications.init(tz.local);

  runApp(Affirmations(initSettings: initSettings));
}

//Affirmations class to run the app
class Affirmations extends StatefulWidget {
  final Settings initSettings;
  const Affirmations({super.key, required this.initSettings});

  @override
  State<Affirmations> createState() => _AffirmationsState();
}

//_AffirmationsState class to run the app
class _AffirmationsState extends State<Affirmations> {
  late Settings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.initSettings;
  }

  // Function to check for current settings and update if needed
  void updateSettings(Settings newSettings) async {
    setState(() {
      _currentSettings = newSettings;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', _currentSettings.id);
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
