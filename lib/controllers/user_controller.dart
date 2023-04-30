import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/services/messaging_service.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MessagingService _messaging = MessagingService();

  // user creation:
  Future createUser(String? uid, String name, UserType type) async {
    // type : student , ta , professor , admin
    final docUser = Database.users.doc(uid);

    // ignore: prefer_typing_uninitialized_variables
    final user;

    String? token = await _messaging.getToken();

    switch (type) {
      case UserType.student:
        user = Student(
            id: uid,
            token: token,
            name: name,
            type: type,
            courses: [],
            notifications: [],
            quizReminder: 1,
            assignmentReminder: 1);
        break;
      case UserType.professor:
        user = Professor(
            id: uid,
            token: token,
            name: name,
            type: type,
            courses: [],
            notifications: []);
        break;
      case UserType.ta:
        user = TA(
            id: uid,
            token: token,
            name: name,
            type: type,
            courses: [],
            notifications: []);
        break;
      default:
        user = UserModel(
            id: uid, token: token, name: name, type: type, notifications: []);
        break;
    }
    final json = user.toJson();
    await docUser.set(json);
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
    if (_auth.currentUser == null) return null;
    final userDoc =
        await Database.getDocumentData(Database.users, _auth.currentUser?.uid);
    return userDoc;
  }

  Future notifyUser(String uid, String title, String body) async {
    UserModel? user = await Database.getUser(uid);
    if (user?.token != null) {
      await _messaging.sendPushNotification(user?.token ?? '', body, title);
    }
  }

  Future notifyUsers(List<String> uids, String title, String body) async {
    List<Future> notifying = [];
    for (String uid in uids) {
      if (uid != _auth.currentUser?.uid) {
        notifying.add(notifyUser(uid, title, body));
      }
    }
    await Future.wait(notifying);
  }
}
