import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CustomImageHandler {
  static const _imageKey = 'background_image_path';

  // Load the saved image from sharedPreferences
  Future<File?> loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imageKey);
    if (imagePath == null) {
      return null; // No saved image
    }
    final imageFile = File(imagePath);
    if (await imageFile.exists()) {
      return imageFile; // Return the saved image if it exists
    } else {
      // If the saved image doesn't exist, remove the key from sharedPreferences
      await prefs.remove(_imageKey);
      return null;
    }
  }

  // Save the picked image to sharedPreferences and return the saved image
  // If the image is not picked, return null
  Future<File?> pickAndSaveImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    // Pick the image from the source
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile == null) {
      return null; // No image picked or User canceled the picker
    }
    // Save the picked image to the app's directory
    final appDirectory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedFile.path);
    final savedImagePath = path.join(appDirectory.path, fileName);
    // Copy the picked image to the app's directory
    final savedImageFile = await File(pickedFile.path).copy(savedImagePath);
    // Save the image path to sharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageKey, savedImagePath);
    return savedImageFile;
  }

  // Remove the saved image from sharedPreferences
  Future<void> clearSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imageKey);
    if (imagePath != null) {
      // Delete the file from storage
      final imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      // Remove the key from sharedPreferences
      await prefs.remove(_imageKey);
    }
  }
}
