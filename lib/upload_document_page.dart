import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'firestore_service.dart';
import 'language_provider.dart';
import 'translations.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  bool _uploading = false;
  String _status = '';

  /// ------------------------------------------------------------
  /// PICK FILE → ASK FOR RENAME → UPLOAD TO STORAGE + FIRESTORE
  /// ------------------------------------------------------------
  Future<void> _pickAndUploadFile() async {
    try {
      // Step 1: Pick file
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.first;
      if (pickedFile.path == null) {
        setState(() => _status = 'Invalid file selected.');
        return;
      }

      // Step 2: Ask user for custom name
      final customName = await showDialog<String>(
        context: context,
        builder: (context) {
          final controller = TextEditingController(text: pickedFile.name);

          return AlertDialog(
            title: const Text("Rename File"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Enter new file name",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text("Save"),
              ),
            ],
          );
        },
      );

      // User pressed Cancel
      if (customName == null || customName.isEmpty) {
        setState(() => _status = 'Upload cancelled.');
        return;
      }

      // Preparing UI
      setState(() {
        _uploading = true;
        _status = 'Uploading $customName...';
      });

      // Step 3: Upload to Firebase
      await FirestoreService.uploadFile(
        File(pickedFile.path!),
        customName,                   // USE THE CUSTOM NAME
        pickedFile.size,
        pickedFile.extension,
      );

      // Success
      setState(() {
        _uploading = false;
        _status = 'Upload complete: $customName';
      });
    } catch (e) {
      // Error
      setState(() {
        _uploading = false;
        _status = 'Upload failed: $e';
      });
    }
  }

  /// ------------------------------------------------------------
  /// PAGE UI
  /// ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final language = Provider.of<LanguageProvider>(context).currentLanguage;

    return Scaffold(
      appBar: AppBar(title: Text(AppTranslations.get('file_upload', language))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _uploading ? null : _pickAndUploadFile,
              icon: const Icon(Icons.upload_file),
              label: Text(AppTranslations.get('choose_file_upload', language)),
            ),
            const SizedBox(height: 20),

            if (_uploading) const CircularProgressIndicator(),

            if (_status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
