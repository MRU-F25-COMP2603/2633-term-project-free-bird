import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  static final _filesRef = FirebaseFirestore.instance.collection('files');
  static final _storage = FirebaseStorage.instance;

  static Future<void> uploadFile(File file, String name, int size, String? extension) async {
    final fileRef = _storage.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}_$name');
    await fileRef.putFile(file);
    final url = await fileRef.getDownloadURL();

    await _filesRef.add({
      'name': name,
      'url': url,
      'storagePath': fileRef.fullPath,
      'type': extension ?? 'unknown',
      'size': size,
      'uploadedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getFilesStream() {
    return _filesRef.orderBy('uploadedAt', descending: true).snapshots();
  }

  static Future<void> deleteFile(String docId, String? storagePath) async {
    try {
      if (storagePath != null && storagePath.isNotEmpty) {
        await _storage.ref().child(storagePath).delete();
      }
      await _filesRef.doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
