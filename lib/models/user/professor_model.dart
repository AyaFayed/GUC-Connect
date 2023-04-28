import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class Professor extends UserModel {
  List<ProfessorCourse> courses;

  Professor({
    required super.id,
    required super.token,
    required super.name,
    required super.type,
    required super.notifications,
    required this.courses,
  });

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'courses': courses.map((course) => course.toJson()).toList(),
      };

  static Professor fromJson(Map<String, dynamic> json) => Professor(
        id: json['id'],
        token: json['token'],
        name: json['name'],
        type: getUserTypeFromString(json['type']),
        notifications: (json['notifications'] as List<dynamic>)
            .map((notification) => UserNotification.fromJson(notification))
            .toList(),
        courses: (json['courses'] as List<dynamic>)
            .map((course) => ProfessorCourse.fromJson(course))
            .toList(),
      );
}

class ProfessorCourse {
  String id;
  List<String> groups;
  List<String> announcements;
  List<String> quizzes;
  List<String> assignments;
  List<String> compensationLectures;

  ProfessorCourse({
    required this.id,
    required this.groups,
    required this.announcements,
    required this.quizzes,
    required this.assignments,
    required this.compensationLectures,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'groups': groups,
        'announcements': announcements,
        'quizzes': quizzes,
        'assignments': assignments,
        'compensationLectures': compensationLectures,
      };

  static ProfessorCourse fromJson(Map<String, dynamic> json) => ProfessorCourse(
        id: json['id'],
        groups: (json['groups'] as List<dynamic>).cast<String>(),
        announcements: (json['announcements'] as List<dynamic>).cast<String>(),
        quizzes: (json['quizzes'] as List<dynamic>).cast<String>(),
        assignments: (json['assignments'] as List<dynamic>).cast<String>(),
        compensationLectures:
            (json['compensationLectures'] as List<dynamic>).cast<String>(),
      );
}
