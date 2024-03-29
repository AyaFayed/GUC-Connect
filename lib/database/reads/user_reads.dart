import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';

class UserReads {
  final CollectionReference<Map<String, dynamic>> _users =
      DatabaseReferences.users;

  Future<UserModel?> getUser(String userId) async {
    try {
      final userIdData = await DatabaseReferences.getDocumentData(
          DatabaseReferences.users, userId);
      if (userIdData != null) {
        UserModel user = UserModel.fromJson(userIdData);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _users.get();

      List<UserModel> allUsers = querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allUsers;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserModel>> getAllUserIdsEnrolledInACourse(
      String courseId) async {
    try {
      QuerySnapshot querySnapshot =
          await _users.where('courseIds', arrayContains: courseId).get();

      List<UserModel> users = querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return users;
    } catch (e) {
      return [];
    }
  }
}
