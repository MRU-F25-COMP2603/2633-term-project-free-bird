import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'firestore_service.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  bool _uploading = false;
  String _status = '';

  Future<void> _pickAndUploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.path == null) {
        setState(() => _status = 'Invalid file');
        return;
      }

      setState(() {
        _uploading = true;
        _status = 'Uploading ${file.name}...';
      });

      await FirestoreService.uploadFile(
        File(file.path!),
        file.name,
        file.size,
        file.extension,
      );

      setState(() {
        _uploading = false;
        _status = 'Upload complete: ${file.name}';
      });
    } catch (e) {
      setState(() {
        _uploading = false;
        _status = 'Upload failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Upload')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _uploading ? null : _pickAndUploadFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Choose File & Upload'),
            ),
            const SizedBox(height: 20),
            if (_uploading) const CircularProgressIndicator(),
            if (_status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_status, textAlign: TextAlign.center),
              ),
          ],
        ),
      ),
    );
  }
}
