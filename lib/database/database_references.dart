import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseReferences {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> courses =
      database.collection('courses');
  static CollectionReference<Map<String, dynamic>> users =
      database.collection('users');
  static CollectionReference<Map<String, dynamic>> groups =
      database.collection('groups');
  static CollectionReference<Map<String, dynamic>> announcements =
      database.collection('announcements');
  static CollectionReference<Map<String, dynamic>> assignments =
      database.collection('assignments');
  static CollectionReference<Map<String, dynamic>> scheduledEvents =
      database.collection('scheduledEvents');
  static CollectionReference<Map<String, dynamic>> posts =
      database.collection('posts');
  static CollectionReference<Map<String, dynamic>> notifications =
      database.collection('notifications');

  static Future<Map<String, dynamic>?> getDocumentData(
      CollectionReference<Map<String, dynamic>> docRef, String? docId) async {
    final doc = docRef.doc(docId);
    final snapshot = await doc.get();

    if (snapshot.exists) {
      return snapshot.data();
    }
    return null;
  }
}
