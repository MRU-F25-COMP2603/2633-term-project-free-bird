import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference documents =
      FirebaseFirestore.instance.collection('Documents');

  Future<void> addDocument({
    required String userID,
    required String documentName,
    required String fileType,
  }) async {
    await documents.add({
      'userID': userID,
      'documentName': documentName,
      'fileType': fileType,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
