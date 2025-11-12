import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:ui';
import 'package:be_kind_2_u/Screens/check_in.dart';
import 'package:be_kind_2_u/brain/settings.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'brain/notifications.dart';
import 'dart:core';

import 'gears/affirmation_provider.dart';

//main function to run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('affirmations');
  await Hive.openBox('custom_image');

  tz.initializeTimeZones();
  Future<void> findingCurrentLocation() async {
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  await findingCurrentLocation();

  // Check Hive for saved settings and defaulted to 'loved' if empty
  final settingsBox = Hive.box('settings');
  final settingsId = settingsBox.get('settings') ?? Settings.loved.id;
  final initSettings = Settings.allSettings[settingsId] ?? Settings.loved;
  // initialize affirmations and get the stored list of still available affirmations
  final provider = AffirmationProvider.withDefaultAffirmations();
  await provider.init();

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

    final settingsBox = Hive.box('settings');
    await settingsBox.put('settings', _currentSettings.id);
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
