import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'upload_document_page.dart';
import 'stored_documents_page.dart';
import 'language_provider.dart';
import 'translations.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final language = LanguageProvider.currentOrDefault(context);
    // Make buttons responsive to screen size, but not too large
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = min(screenWidth * 0.22, 140.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('documents', language)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // File Upload button
            SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FileUploadPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(AppTranslations.get('file_upload', language), textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(width: 20),
            // Stored Documents button
            SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StoredDocumentsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(AppTranslations.get('stored_documents', language), textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
