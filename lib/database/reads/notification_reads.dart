import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/notification/notification_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';

class NotificationReads {
  Future<NotificationModel?> getNotification(String notificationId) async {
    final notificationData = await DatabaseReferences.getDocumentData(
        DatabaseReferences.notifications, notificationId);
    if (notificationData != null) {
      NotificationModel notification =
          NotificationModel.fromJson(notificationData);
      return notification;
    }
    return null;
  }

  Future<NotificationDisplay?> getDisplayNotification(
      UserNotification userNotification) async {
    final notificationData = await DatabaseReferences.getDocumentData(
        DatabaseReferences.notifications, userNotification.id);

    if (notificationData != null) {
      NotificationModel notification =
          NotificationModel.fromJson(notificationData);
      NotificationDisplay notificationDisplay = NotificationDisplay(
          notification: notification, seen: userNotification.seen);
      return notificationDisplay;
    }
    return null;
  }

  Future<List<NotificationDisplay>> getNotificationListFromUserNotifications(
      List<UserNotification> userNotifications) async {
    List<NotificationDisplay?> notificationsNull = await Future.wait(
        userNotifications.map((UserNotification userNotification) {
      return getDisplayNotification(userNotification);
    }));

    List<NotificationDisplay> notifications = [];
    for (NotificationDisplay? notification in notificationsNull) {
      if (notification != null) {
        notifications.add(notification);
      }
    }
    return notifications;
  }
}
