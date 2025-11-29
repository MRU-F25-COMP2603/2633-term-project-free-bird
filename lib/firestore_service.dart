import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final _filesRef = FirebaseFirestore.instance.collection('files');
  static final _storage = FirebaseStorage.instance;

  static Future<void> uploadFile(File file, String name, int size, String? extension) async {
    // Get current user
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final fileRef = _storage
        .ref()
        .child('uploads/$userId/${DateTime.now().millisecondsSinceEpoch}_$name');
    await fileRef.putFile(file);
    final url = await fileRef.getDownloadURL();

    await _filesRef.add({
      'userId': userId,
      'ownerEmail': user?.email ?? 'unknown',
      'sharedWith': <String>[],
      'name': name,
      'url': url,
      'storagePath': fileRef.fullPath,
      'type': extension ?? 'unknown',
      'size': size,
      'uploadedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getFilesStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Return an empty stream if no user is authenticated
      return const Stream.empty();
    }
    // Note: Removed orderBy to avoid needing a composite index
    // Files will be sorted client-side in the UI if needed
    return _filesRef
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  static Stream<QuerySnapshot> getSharedFilesStream() {
    final email = FirebaseAuth.instance.currentUser?.email?.toLowerCase();
    if (email == null || email.isEmpty) {
      return const Stream.empty();
    }
    return _filesRef
        .where('sharedWith', arrayContains: email)
        .snapshots();
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
