import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // user creation:
  Future createUser(String? uid, String name, UserType type) async {
    // type : student , ta , professor , admin
    final docUser = Database.users.doc(uid);

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
    final userDoc = await getCurrentUser();

    if (userDoc != null) {
      final user = UserModel.fromJson(userDoc);
      return user.type;
    } else {
      return UserType.student;
    }
  }

  Future<UserType> getUserType(String uid) async {
    UserModel? user = await Database.getUser(uid);

    if (user != null) {
      return user.type;
    } else {
      return UserType.student;
    }
  }

  Future<String> getUserName(String uid) async {
    UserModel? user = await Database.getUser(uid);

    if (user != null) {
      return user.name;
    } else {
      return '';
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final userDoc =
        await Database.getDocumentData(Database.users, _auth.currentUser?.uid);
    return userDoc;
  }
}
