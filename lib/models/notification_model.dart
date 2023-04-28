import 'package:flutter/widgets.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class Notification {
  String id;
  String courseName;
  String title;
  String body;
  DateTime createdAt;
  bool opened;
  String eventId;
  NotificationType notificationType;

  Notification({
    required this.id,
    required this.courseName,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.opened,
    required this.eventId,
    required this.notificationType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseName': courseName,
        'title': title,
        'body': body,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'opened': opened,
        'eventId': eventId,
        'notificationType': notificationType.name
      };

  static Notification fromJson(Map<String, dynamic> json) => Notification(
      id: json['id'],
      courseName: json['courseName'],
      title: json['title'],
      body: json['body'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      opened: json['opened'],
      eventId: json['eventId'],
      notificationType:
          getNotificationTypeFromString(json['notificationType']));
}
