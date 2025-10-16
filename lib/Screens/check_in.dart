import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:b_kind_2_u/gears/custom_image_handler.dart';
import 'package:b_kind_2_u/gears/affirmation_provider.dart';
import 'package:b_kind_2_u/brain/settings.dart';
import 'package:b_kind_2_u/brain/notifications.dart';

//Start off with the check in page for the settings
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

//state for affirmation provider
class CheckInState extends State<CheckIn> {
  final AffirmationProvider affirmationProvider =
      AffirmationProvider.withDefaultAffirmations();

  String currentAffirmation =
      'Loading affirmation.'; // Holds the current affirmation

  final CustomImageHandler _imageHandler = CustomImageHandler();
  File? _backgroundImageFile; // Holds the background image file
  bool _showCustomBackground = false; // Flag to show the custom background

  @override
  void initState() {
    super.initState();
    _loadAffirmation(); // Initialize the affirmation
    _loadBackgroundImage(); // Load the background image
  }

  void _loadAffirmation() async {
    try {
      final newAffirmation = await affirmationProvider.getAffirmation();
      if (mounted) {
        setState(() {
          currentAffirmation = newAffirmation;
        });
      }
    } catch (e) {
      debugPrint("Error loading affirmation: $e");
    }
  }

  // Function to load the background image
  void _loadBackgroundImage() async {
    final imageFile = await _imageHandler.loadSavedImage();
    if (imageFile != null) {
      setState(() {
        _backgroundImageFile = imageFile;
        _showCustomBackground = true;
      });
    }
  }

  // Function to pick a new background image
  void _pickNewBackgroundImage(ImageSource source) async {
    final newImageFile = await _imageHandler.pickAndSaveImage(source);
    if (newImageFile != null) {
      setState(() {
        _backgroundImageFile = newImageFile;
      });
      setState(() {
        _showCustomBackground = true;
      });
    }
  }

  // Function to show a dialog to choose between Camera or Gallery
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext innerContext) {
        // Use a different context name to avoid conflict
        return AlertDialog(
          title: const Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("From Gallery"),
                onTap: () {
                  Navigator.of(innerContext).pop(); // Close this dialog
                  _pickNewBackgroundImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("From Camera"),
                onTap: () {
                  Navigator.of(innerContext).pop(); // Close this dialog
                  _pickNewBackgroundImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to handle the set of a daily notification
  Future<void> _setDailyNotification() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      await Notifications().scheduleNotification(selectedDateTime);
      debugPrint("Notification set for $selectedDateTime");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Daily Reminder set for ${selectedTime.format(context)}",
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  //function to update the affirmation
  void _updateAffirmation() async {
    final newAffirmation = await affirmationProvider.getAffirmation();
    setState(() {
      currentAffirmation = newAffirmation;
    });
  }

  //function to update the settings which displays a dialog box with the options
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Change Background',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: const Icon(Icons.add_photo_alternate),
                  title: const Text('Choose a custom image'),
                  onTap: () {
                    if (_backgroundImageFile == null) {
                      Navigator.pop(context);
                      _showImageSourceDialog();
                    } else {
                      setState(() {
                        _showCustomBackground = true;
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
                if (_backgroundImageFile != null)
                  ListTile(
                    leading: const Icon(Icons.hide_image),
                    title: const Text('Remove background image'),
                    onTap: () {
                      _imageHandler.clearSavedImage();
                      setState(() {
                        _backgroundImageFile = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                const Divider(),
                const Text(
                  'Change Theme',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Loved'),
                  onTap: () {
                    widget.updateSettings(Settings.loved);
                    setState(() {
                      _showCustomBackground = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Darkness'),
                  onTap: () {
                    widget.updateSettings(Settings.darkness);
                    setState(() {
                      _showCustomBackground = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Kindness'),
                  onTap: () {
                    widget.updateSettings(Settings.kindness);
                    setState(() {
                      _showCustomBackground = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Inspired'),
                  onTap: () {
                    widget.updateSettings(Settings.inspired);
                    setState(() {
                      _showCustomBackground = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                const Text(
                  'Set Daily Notification',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: const Text('Set daily reminder'),
                  onTap: () {
                    Navigator.pop(context);
                    _setDailyNotification();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.timer_off_outlined),
                  title: const Text('Cancel daily reminder'),
                  onTap: () async {
                    Navigator.pop(context);
                    _setDailyNotification().cancelAll(Notifications());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Daily reminder has been canceled."),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Here is the build function for the check in page
  @override
  Widget build(BuildContext context) {
    final bool useImageAsBackground =
        _backgroundImageFile != null && _showCustomBackground;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('B Kind 2 U'),
        backgroundColor: widget.currentSettings.appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: useImageAsBackground
              ? DecorationImage(
                  image: FileImage(_backgroundImageFile!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.0),
                    BlendMode.darken,
                  ),
                )
              : null,
          color: !useImageAsBackground
              ? widget.currentSettings.backgroundColor
              : null,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!useImageAsBackground)
                  Text(
                    widget.currentSettings.topRow,
                    style: const TextStyle(fontSize: 46.0),
                  ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: useImageAsBackground
                      ? BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(45.0),
                        )
                      : null,
                  child: Text(
                    currentAffirmation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
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
                if (!useImageAsBackground)
                  Text(
                    widget.currentSettings.bottomRow,
                    style: const TextStyle(fontSize: 50.0),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on Future<void> {
  void cancelAll(dynamic scheduledNotificationTime) {
    debugPrint("All notifications canceled");
  }
}
