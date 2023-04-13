import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class UserController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // user creation:
  Future createUser(String? uid, String name, UserType type) async {
    // type : student , ta , professor , admin
    final docUser = _database.collection('users').doc(uid);

    // ignore: prefer_typing_uninitialized_variables
    final user;

    switch (type) {
      case UserType.student:
        user = Student(id: uid, name: name, type: type, courses: []);
        break;
      case UserType.professor:
        user = Professor(id: uid, name: name, type: type, courses: []);
        break;
      case UserType.ta:
        user = TA(id: uid, name: name, type: type, courses: []);
        break;
      default:
        user = UserModel(
          id: uid,
          name: name,
          type: type,
        );
        break;
    }
    final json = user.toJson();
    try {
      await docUser.set(json);
    } catch (e) {
      // print(e);
    }
  }

  Future<UserType> getCurrentUserType() async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      final type = getUserTypeFromString(user!['type']);
      return type;
    } else {
      return UserType.student;
    }
  }

  Future<UserType> getUserType(String uid) async {
    final docUser = _database.collection('users').doc(uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      final type = getUserTypeFromString(user!['type']);
      return type;
    } else {
      return UserType.student;
    }
  }

  Future<String> getUserName(String uid) async {
    final docUser = _database.collection('users').doc(uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data();
      final user = UserModel.fromJson(userData!);
      return user.name;
    } else {
      return '';
    }
  }
}
