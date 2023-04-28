import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/notification_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class NotificationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createNotification(
      List<String> userIds,
      String? courseName,
      String title,
      String body,
      String eventId,
      NotificationType notificationType) async {
    final docNotification = Database.notifications.doc();

    final notification = NotificationModel(
        id: docNotification.id,
        courseName: courseName,
        title: title,
        body: body,
        createdAt: DateTime.now(),
        eventId: eventId,
        notificationType: notificationType);

    final json = notification.toJson();

    await docNotification.set(json);

    final userNotification =
        UserNotification(id: docNotification.id, seen: false);

    List<Future> updates = [];

    for (String userId in userIds) {
      updates.add(Database.users.doc(userId).update({
        'notifications': FieldValue.arrayUnion([userNotification.toJson()])
      }));
    }

    await Future.wait(updates);
  }

  Future markNotificationAsSeen(String notificationId) async {
    UserModel? currentUser =
        await Database.getUser(_auth.currentUser?.uid ?? '');
    if (currentUser != null) {
      currentUser.notifications
          .removeWhere((notification) => notification.id == notificationId);
      currentUser.notifications
          .add(UserNotification(id: notificationId, seen: true));

      await Database.users.doc(_auth.currentUser?.uid).update({
        'notifications': currentUser.notifications
            .map((notification) => notification.toJson())
      });
    }
  }

  Future<List<NotificationDisplay>> getMyNotifications() async {
    UserModel? currentUser =
        await Database.getUser(_auth.currentUser?.uid ?? '');
    if (currentUser != null) {
      return await Database.getNotificationListFromUserNotifications(
          currentUser.notifications);
    }
    return [];
  }
}
