import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:isolate';

// --- Isolate Functions (Now dumber and safer) ---

// This function ONLY does the slow file copy.
// It receives the directory path from the main thread.
Future<String> _copyFileIsolate(Map<String, String> args) async {
  final pickedFilePath = args['pickedFilePath']!;
  final appDirectoryPath = args['appDirectoryPath']!;
  final savedFileName = path.basename(pickedFilePath);
  final newPath = path.join(appDirectoryPath, savedFileName);

  await File(pickedFilePath).copy(newPath);
  return newPath; // Return the path of the newly created file
}

// This function ONLY does the slow file deletion.
// It receives the full file path to delete.
Future<void> _deleteFileIsolate(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    await file.delete();
  }
}

// --- CustomImageHandler Class ---

class CustomImageHandler {
  static const imageKey = 'background_image_path';

  Future<File?> loadSavedImage() async {
    // SharedPreferences is fast, so we do it on the main thread.
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(imageKey);

    if (imagePath != null) {
      final imageFile = File(imagePath);
      // We still need to check if the file exists, which is I/O.
      // But this is much lighter than copying/deleting.
      // For now, we accept this minor I/O on the main thread to ensure stability.
      if (await imageFile.exists()) {
        return imageFile;
      } else {
        // Cleanup bad reference
        await prefs.remove(imageKey);
      }
    }
    return null;
  }

  Future<File?> pickAndSaveImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile == null) return null;

    // 1. Get the directory on the main thread (fast, reliable).
    final appDirectory = await getApplicationDocumentsDirectory();

    // 2. Pass paths to the isolate for the heavy lifting.
    final newPath = await Isolate.run(
      () => _copyFileIsolate({
        'pickedFilePath': pickedFile.path,
        'appDirectoryPath': appDirectory.path,
      }),
    );

    // 3. Save the result to SharedPreferences on the main thread (fast, reliable).
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(imageKey, newPath);

    return File(newPath);
  }

  Future<void> clearSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(imageKey);

    if (imagePath != null) {
      // 1. Do the heavy file deletion in the background.
      await Isolate.run(() => _deleteFileIsolate(imagePath));

      // 2. Remove the key on the main thread (fast, reliable).
      await prefs.remove(imageKey);
    }
  }
}
