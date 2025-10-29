import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoredDocumentsPage extends StatelessWidget {
  const StoredDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference documents =
        FirebaseFirestore.instance.collection('Documents');

    return Scaffold(
      appBar: AppBar(title: const Text('Stored Documents')),
      body: StreamBuilder<QuerySnapshot>(
        stream: documents.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading documents ❌'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No documents uploaded yet.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              return ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(doc['documentName']),
                subtitle: Text('${doc['fileType']} | ${doc['userID']}'),
              );
            },
          );
        },
      ),
    );
  }
}
