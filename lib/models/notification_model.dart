import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class NotificationModel {
  String id;
  String courseName;
  String title;
  String body;
  DateTime createdAt;
  String eventId;
  NotificationType notificationType;

  NotificationModel({
    required this.id,
    required this.courseName,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.eventId,
    required this.notificationType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseName': courseName,
        'title': title,
        'body': body,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'eventId': eventId,
        'notificationType': notificationType.name
      };

  static NotificationModel fromJson(
          Map<String, dynamic> json) =>
      NotificationModel(
          id: json['id'],
          courseName: json['courseName'],
          title: json['title'],
          body: json['body'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
          eventId: json['eventId'],
          notificationType:
              getNotificationTypeFromString(json['notificationType']));
}

class NotificationDisplay {
  NotificationModel notification;
  bool seen;

  NotificationDisplay({
    required this.notification,
    required this.seen,
  });
}
