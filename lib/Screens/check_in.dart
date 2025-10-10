import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:b_kind_2_u/gears/custom_image_handler.dart';
import 'package:b_kind_2_u/gears/affirmation_provider.dart';
import 'package:b_kind_2_u/brain/settings.dart';

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

  late String currentAffirmation; // Holds the current affirmation

  final CustomImageHandler _imageHandler = CustomImageHandler();
  File? _backgroundImageFile; // Holds the background image file

  @override
  void initState() {
    super.initState();
    currentAffirmation = affirmationProvider
        .getAffirmation(); // Initialize the affirmation
    _loadBackgroundImage(); // Load the background image
  }

  // Function to load the background image
  void _loadBackgroundImage() async {
    final imageFile = await _imageHandler.loadSavedImage();
    if (imageFile != null) {
      setState(() {
        _backgroundImageFile = imageFile;
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

  //function to update the affirmation
  void _updateAffirmation() {
    setState(() {
      currentAffirmation = affirmationProvider.getAffirmation();
    });
  }

  //function to update the settings which displays a dialog box with the options
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

  //Here is the build function for the check in page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.currentSettings.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('B Kind 2 U'),
        backgroundColor: widget.currentSettings.appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
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
