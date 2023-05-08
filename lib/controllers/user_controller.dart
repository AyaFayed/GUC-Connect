import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/database/reads/user_reads.dart';
import 'package:guc_scheduling_app/database/writes/user_writes.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/services/messaging_service.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MessagingService _messaging = MessagingService();
  final UserReads _userReads = UserReads();
  final UserWrites _userWrites = UserWrites();

  Future createUser(String? uid, String name, UserType type) async {
    final docUser = DatabaseReferences.users.doc(uid);

    String? token = await _messaging.getToken();

    UserModel user = UserModel(
        id: docUser.id,
        tokens: token != null ? [token] : [],
        name: name,
        type: type,
        allowPostNotifications: true,
        userNotifications: [],
        courseIds: []);

    final json = user.toJson();
    await docUser.set(json);
  }

  Future<UserType?> getCurrentUserType() async {
    UserModel? user = await getCurrentUser();

    if (user != null) {
      return user.type;
    } else {
      return null;
    }
  }

  Future<bool> isCurrentUserInstructor() async {
    UserType? userType = await getCurrentUserType();

    if (userType == UserType.professor || userType == UserType.ta) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserType?> getUserType(String uid) async {
    UserModel? user = await _userReads.getUser(uid);

    if (user != null) {
      return user.type;
    } else {
      return null;
    }
  }

  Future<String> getUserName(String uid) async {
    UserModel? user = await _userReads.getUser(uid);

    if (user != null) {
      return user.name;
    } else {
      return '';
    }
  }

  Future<UserModel?> getCurrentUser() async {
    if (_auth.currentUser == null) return null;
    UserModel? user = await _userReads.getUser(_auth.currentUser?.uid ?? '');
    return user;
  }

  Future notifyUser(String uid, String title, String body) async {
    UserModel? user = await _userReads.getUser(uid);

    if (user != null) {
      List<Future> notifying = [];
      for (String token in user.tokens) {
        notifying.add(_messaging.sendPushNotification(token, body, title));
      }
      await Future.wait(notifying);
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

  Future remindCurrentUser(
      String title, String body, DateTime reminderDateTime) async {
    if (_auth.currentUser == null) return;

    await remindUser(
        _auth.currentUser?.uid ?? '', title, body, reminderDateTime);
  }

  Future remindUser(
      String uid, String title, String body, DateTime reminderDateTime) async {
    UserModel? user = await _userReads.getUser(uid);

    if (user != null) {
      List<Future> reminding = [];
      for (String token in user.tokens) {
        reminding
            .add(_messaging.sendReminder(token, body, title, reminderDateTime));
      }
      await Future.wait(reminding);
    }
  }

  Future remindUsers(List<String> uids, String title, String body,
      DateTime reminderDateTime) async {
    List<Future> reminding = [];
    for (String uid in uids) {
      if (uid != _auth.currentUser?.uid) {
        reminding.add(remindUser(uid, title, body, reminderDateTime));
      }
    }
    await Future.wait(reminding);
  }

  Future updateAllowPostNotifications(bool value) async {
    if (_auth.currentUser == null) return;
    await _userWrites.updateAllowPostNotifications(
        _auth.currentUser?.uid ?? '', value);
  }

  Future<int> getNotificationsCount() async {
    UserModel? currentUser = await getCurrentUser();
    int count = 0;
    if (currentUser != null) {
      for (UserNotification userNotification in currentUser.userNotifications) {
        if (!userNotification.seen) {
          count++;
        }
      }
    }
    return count;
  }
}
