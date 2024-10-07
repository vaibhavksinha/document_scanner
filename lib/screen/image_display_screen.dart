import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class ImageDisplayScreen extends StatelessWidget {
  final String imagePath;

  const ImageDisplayScreen({super.key, required this.imagePath});

  // Function to navigate to edit screen
  void _navigateToEditScreen() async {
    final editedImage = await Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => ImageEditor(
          image: File(imagePath).readAsBytesSync(),
        ),
      ),
    );

    if (editedImage != null) {
      final String newPath = imagePath.replaceAll('.jpg', '_edited.jpg');
      await File(newPath).writeAsBytes(editedImage);
      Get.off(() => ImageDisplayScreen(imagePath: newPath),
          transition: Transition.fade);
    }
  }

  // Function to save image as PDF
  Future<void> _saveAsPdf() async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(File(imagePath).readAsBytesSync());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${output.path}/pdfs');
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }
    final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${pdfDir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    Get.snackbar('Success', 'PDF saved to ${file.path}');

    // Open the PDF file
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditScreen,
          ),
        ],
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
      bottomNavigationBar: SizedBox(
        height: 95, // Increased from 65 to 95 (30 pixels more)
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: _saveAsPdf,
                  ),
                  const Text('Save as PDF'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
