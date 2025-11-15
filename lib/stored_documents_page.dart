import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'firestore_service.dart';

class StoredDocumentsPage extends StatelessWidget {
  const StoredDocumentsPage({super.key});

  Future<void> _downloadFile(String url, String fileName, BuildContext context) async {
    try {
      final resp = await http.get(Uri.parse(url));
      final dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(resp.bodyBytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Download failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stored Documents')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.getFilesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var docs = snapshot.data?.docs ?? [];
          
          // Sort documents by uploadedAt timestamp (most recent first)
          docs.sort((a, b) {
            final aTime = (a.data() as Map<String, dynamic>)['uploadedAt'] as Timestamp?;
            final bTime = (b.data() as Map<String, dynamic>)['uploadedAt'] as Timestamp?;
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });
          
          if (docs.isEmpty) {
            return const Center(child: Text('No files found.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final fileName = data['name'] ?? 'Unnamed';
              final url = data['url'] ?? '';
              final path = data['storagePath'] as String?;

              return ListTile(
                leading: Icon(Icons.insert_drive_file, color: Colors.blueAccent),
                title: Text(fileName),
                subtitle: Text('${(data['size'] / 1024).toStringAsFixed(1)} KB'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _downloadFile(url, fileName, context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await FirestoreService.deleteFile(docs[i].id, path);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted $fileName')));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
