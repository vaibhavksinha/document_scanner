import 'dart:io';
import 'package:document_scanning/screen/image_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Function to capture image from camera
  Future<void> _captureImage() async {
    final picker.ImagePicker imagePicker = picker.ImagePicker();
    final picker.XFile? image =
        await imagePicker.pickImage(source: picker.ImageSource.camera);

    if (image != null) {
      Get.to(() => ImageDisplayScreen(imagePath: image.path),
          transition: Transition.zoom);
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final picker.ImagePicker imagePicker = picker.ImagePicker();
    final picker.XFile? image =
        await imagePicker.pickImage(source: picker.ImageSource.gallery);

    if (image != null) {
      Get.to(() => ImageDisplayScreen(imagePath: image.path),
          transition: Transition.zoom);
    }
  }

  // Function to toggle between light and dark theme
  void _toggleTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  // Function to open saved PDF
  Future<void> _openSavedPdf() async {
    final output = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${output.path}/pdfs');
    if (await pdfDir.exists()) {
      final files = pdfDir
          .listSync()
          .where((file) => file.path.endsWith('.pdf'))
          .toList();
      if (files.isNotEmpty) {
        final selectedFile = await showDialog<File>(
          context: Get.context!,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Select a PDF'),
              children: files.map((file) {
                return SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, file as File);
                  },
                  child: Text(file.path.split('/').last),
                );
              }).toList(),
            );
          },
        );
        if (selectedFile != null) {
          await OpenFile.open(selectedFile.path);
        }
      } else {
        Get.snackbar('Error', 'No saved PDFs found');
      }
    } else {
      Get.snackbar('Error', 'No saved PDFs found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Capture'),
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            'Tap the button to capture an image',
            key: ValueKey<bool>(Get.isDarkMode),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 95,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _captureImage,
                  ),
                  const Text('Camera'),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: _pickImage,
                  ),
                  const Text('Gallery'),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: _openSavedPdf,
                  ),
                  const Text('Open PDF'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable animated FloatingActionButton widget
class FloatingActionButtonWithAnimation extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String heroTag;

  const FloatingActionButtonWithAnimation({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 200),
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}
