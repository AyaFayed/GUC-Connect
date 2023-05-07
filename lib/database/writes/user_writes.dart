import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';

class UserWrites {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> _users =
      DatabaseReferences.users;

  Future clearAllUserData() async {
    QuerySnapshot querySnapshot = await _users.get();

    await Future.wait(querySnapshot.docs
        .map((doc) => doc.reference.update({'courseIds': []}))
        .toList());
  }

  Future removeCourseFromAllUsers(String courseId) async {
    QuerySnapshot querySnapshot = await _users.get();

    await Future.wait(querySnapshot.docs
        .map((doc) => doc.reference.update({
              'courseIds': FieldValue.arrayRemove([courseId])
            }))
        .toList());
  }

  Future addCourseToUser(String userId, String courseId) async {
    await _users.doc(userId).update({
      'courseIds': FieldValue.arrayUnion([courseId])
    });
  }

  Future removeCourseFromUser(String userId, String courseId) async {
    await _users.doc(userId).update({
      'courseIds': FieldValue.arrayRemove([courseId])
    });
  }

  Future addNotificationToUser(
      String userId, UserNotification userNotification) async {
    await _users.doc(userId).update({
      'userNotifications': FieldValue.arrayUnion([userNotification.toJson()])
    });
  }

  Future markNotificationAsSeen(
      String userId, List<UserNotification> userNotifications) async {
    await _users.doc(userId).update({
      'userNotifications':
          userNotifications.map((notification) => notification.toJson())
    });
  }

  Future updateAllowPostNotifications(String userId, bool value) async {
    await _users.doc(userId).update({'allowPostNotifications': value});
  }

  Future addToken(String token) async {
    if (_auth.currentUser == null) return;
    try {
      await _users.doc(_auth.currentUser?.uid ?? '').update({
        'tokens': FieldValue.arrayUnion([token])
      });
    } catch (e) {
      print(e);
    }
  }

  Future removeToken(String token) async {
    if (_auth.currentUser == null) return;
    try {
      await _users.doc(_auth.currentUser?.uid ?? '').update({
        'tokens': FieldValue.arrayRemove([token])
      });
    } catch (e) {
      print(e);
    }
  }
}
