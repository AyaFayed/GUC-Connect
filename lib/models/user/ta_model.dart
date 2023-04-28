import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class TA extends UserModel {
  List<TACourse> courses;

  TA(
      {required super.id,
      required super.token,
      required super.name,
      required super.type,
      required super.notifications,
      required this.courses});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'courses': courses.map((course) => toJson()).toList()
      };

  static TA fromJson(Map<String, dynamic> json) => TA(
      id: json['id'],
      token: json['token'],
      name: json['name'],
      type: getUserTypeFromString(json['type']),
      notifications: (json['notifications'] as List<dynamic>).cast<String>(),
      courses: (json['courses'] as List<dynamic>)
          .map((course) => TACourse.fromJson(course))
          .toList());
}

class TACourse {
  String id;
  List<String> tutorials;
  List<String> announcements;
  List<String> compensationTutorials;

  TACourse({
    required this.id,
    required this.tutorials,
    required this.announcements,
    required this.compensationTutorials,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tutorials': tutorials,
        'announcements': announcements,
        'compensationTutorials': compensationTutorials,
      };

  static TACourse fromJson(Map<String, dynamic> json) => TACourse(
        id: json['id'],
        tutorials: (json['tutorials'] as List<dynamic>).cast<String>(),
        announcements: (json['announcements'] as List<dynamic>).cast<String>(),
        compensationTutorials:
            (json['compensationTutorials'] as List<dynamic>).cast<String>(),
      );
}
