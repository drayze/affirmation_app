import 'package:flutter/material.dart';
import 'package:b_kind_2_u/Screens/check_in.dart';
import 'package:b_kind_2_u/brain/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

//main function to run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final settingsId = prefs.getString('settings') ?? Settings.loved.id;
  final initSettings = Settings.allSettings[settingsId] ?? Settings.loved;

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
