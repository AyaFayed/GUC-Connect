import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class Student extends UserModel {
  List<StudentCourse> courses;

  Student(
      {required super.id,
      required super.token,
      required super.name,
      required super.type,
      required super.notifications,
      required this.courses});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'courses': courses.map((course) => course.toJson()).toList()
      };

  static Student fromJson(Map<String, dynamic> json) => Student(
      id: json['id'],
      token: json['token'],
      name: json['name'],
      type: getUserTypeFromString(json['type']),
      notifications: (json['notifications'] as List<dynamic>).cast<String>(),
      courses: (json['courses'] as List<dynamic>)
          .map((course) => StudentCourse.fromJson(course))
          .toList());
}

class StudentCourse {
  String id;
  String group;
  String tutorial;

  StudentCourse(
      {required this.id, required this.group, required this.tutorial});

  Map<String, dynamic> toJson() =>
      {'id': id, 'group': group, 'tutorial': tutorial};

  static StudentCourse fromJson(Map<String, dynamic> json) => StudentCourse(
      id: json['id'], group: json['group'], tutorial: json['tutorial']);
}
