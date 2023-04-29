import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class UserModel {
  String? id;
  String? token;
  String name;
  UserType type;
  List<UserNotification> notifications;
  UserModel({
    required this.id,
    required this.token,
    required this.name,
    required this.type,
    required this.notifications,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'name': name,
        'type': type.name,
        'notifications':
            notifications.map((notification) => notification.toJson()).toList(),
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        token: json['token'],
        name: json['name'],
        type: getUserTypeFromString(json['type']),
        notifications: ((json['notifications'] ?? []) as List<dynamic>)
            .map((notification) => UserNotification.fromJson(notification))
            .toList(),
      );
}

class UserNotification {
  String id;
  bool seen;

  UserNotification({required this.id, required this.seen});

  Map<String, dynamic> toJson() => {'id': id, 'seen': seen};

  static UserNotification fromJson(Map<String, dynamic> json) =>
      UserNotification(id: json['id'], seen: json['seen']);
}
