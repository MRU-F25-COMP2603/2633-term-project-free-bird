import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'firestore_service.dart';
import 'language_provider.dart';
import 'translations.dart';

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
    final language = LanguageProvider.currentOrDefault(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppTranslations.get('stored_documents', language))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppTranslations.get('your_documents', language), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 320,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService.getFilesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('${AppTranslations.get('error', language)}: ${snapshot.error}'));
                  }

                  var docs = snapshot.data?.docs ?? [];
                  docs.sort((a, b) {
                    final aTime = (a.data() as Map<String, dynamic>)['uploadedAt'] as Timestamp?;
                    final bTime = (b.data() as Map<String, dynamic>)['uploadedAt'] as Timestamp?;
                    if (aTime == null && bTime == null) return 0;
                    if (aTime == null) return 1;
                    if (bTime == null) return -1;
                    return bTime.compareTo(aTime);
                  });
                  
                  if (docs.isEmpty) {
                    return Center(child: Text(AppTranslations.get('no_files_found', language)));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final doc = docs[i];
                      final data = doc.data() as Map<String, dynamic>;
                      final fileName = data['name'] ?? 'Unnamed';
                      final url = data['url'] ?? '';
                      final path = data['storagePath'] as String?;
                      final shared = (data['sharedWith'] as List?)?.cast<String>() ?? const [];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file, color: Colors.blueAccent),
                          title: Text(fileName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text('${(data['size'] / 1024).toStringAsFixed(1)} ${AppTranslations.get('kb', language)}'),
                              if (shared.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      Text(AppTranslations.get('shared_with', language),
                                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ...shared.map((email) => Chip(
                                            label: Text(email, style: const TextStyle(fontSize: 11)),
                                            deleteIcon: const Icon(Icons.close, size: 16),
                                            onDeleted: () => _unshare(context, doc.id, email),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            visualDensity: VisualDensity.compact,
                                          )),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.share, color: Colors.teal),
                                tooltip: AppTranslations.get('share', language),
                                onPressed: () => _share(context, doc.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                tooltip: AppTranslations.get('download', language),
                                onPressed: () => _downloadFile(url, fileName, context),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                tooltip: AppTranslations.get('delete', language),
                                onPressed: () async {
                                  await FirestoreService.deleteFile(doc.id, path);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text('${AppTranslations.get('deleted', language)} $fileName')));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Text(AppTranslations.get('shared_documents', language), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 320,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService.getSharedFilesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('${AppTranslations.get('error', language)}: ${snapshot.error}'));
                  }

                  var docs = snapshot.data?.docs ?? [];
                  docs.sort((a, b) {
                    final aTime = (a.data() as Map<String, dynamic>)['uploadedAt'] as Timestamp?;
                    final bTime = (b.data() as Map<String, dynamic>)['uploadedAt'] as Timestamp?;
                    if (aTime == null && bTime == null) return 0;
                    if (aTime == null) return 1;
                    if (bTime == null) return -1;
                    return bTime.compareTo(aTime);
                  });

                  if (docs.isEmpty) {
                    return Center(child: Text(AppTranslations.get('no_shared_documents', language)));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final data = docs[i].data() as Map<String, dynamic>;
                      final fileName = data['name'] ?? 'Unnamed';
                      final url = data['url'] ?? '';
                      final owner = data['ownerEmail'] ?? 'Unknown';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.folder_shared, color: Colors.green),
                          title: Text(fileName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${(data['size'] / 1024).toStringAsFixed(1)} KB'),
                              Text('Shared by: $owner',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () => _downloadFile(url, fileName, context),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context, String docId) async {
    final input = TextEditingController();
    final emails = await showDialog<List<String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Share document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter emails (comma-separated).'),
            const SizedBox(height: 8),
            TextField(
              controller: input,
              decoration: const InputDecoration(
                labelText: 'Emails',
                hintText: 'email1@example.com, email2@example.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final list = input.text
                  .split(',')
                  .map((e) => e.trim().toLowerCase())
                  .where((e) => e.isNotEmpty)
                  .toSet()
                  .toList();
              Navigator.pop(ctx, list);
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
    if (emails == null || emails.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('files')
          .doc(docId)
          .update({'sharedWith': FieldValue.arrayUnion(emails)});
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Shared with: ${emails.join(', ')}')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to share: $e')));
      }
    }
  }

  Future<void> _unshare(BuildContext context, String docId, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('files')
          .doc(docId)
          .update({'sharedWith': FieldValue.arrayRemove([email])});
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unshared from: $email')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to unshare: $e')));
      }
    }
  }
}
