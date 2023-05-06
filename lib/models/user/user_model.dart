import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class UserModel {
  String id;
  // tokens for different devices of the same user
  List<String> tokens;
  String name;
  UserType type;
  List<String> courseIds;
  // determines if the user will get push notifications when a new post is added in a course they are enrolled in
  bool allowPostNotifications;
  List<UserNotification> userNotifications;

  UserModel({
    required this.id,
    required this.tokens,
    required this.name,
    required this.type,
    required this.allowPostNotifications,
    required this.userNotifications,
    required this.courseIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tokens': tokens,
        'name': name,
        'type': type.name,
        'allowPostNotifications': allowPostNotifications,
        'userNotifications': userNotifications
            .map((notification) => notification.toJson())
            .toList(),
        'courseIds': courseIds
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      tokens: (json['tokens'] as List<dynamic>).cast<String>(),
      name: json['name'],
      type: getUserTypeFromString(json['type']),
      allowPostNotifications: json['allowPostNotifications'],
      userNotifications: ((json['userNotifications'] ?? []) as List<dynamic>)
          .map((notification) => UserNotification.fromJson(notification))
          .toList(),
      courseIds: (json['courseIds'] as List<dynamic>).cast<String>());
}

class UserNotification {
  String id;
  bool seen;

  UserNotification({required this.id, required this.seen});

  Map<String, dynamic> toJson() => {'id': id, 'seen': seen};

  static UserNotification fromJson(Map<String, dynamic> json) =>
      UserNotification(id: json['id'], seen: json['seen']);
}
