import 'package:guc_scheduling_app/models/divisions/division_model.dart';

class Group extends Division {
  List<String> quizzes;
  List<String> assignments;
  List<String> compensationLectures;

  Group(
      {required super.id,
      required super.courseId,
      required super.number,
      required super.lectures,
      required super.students,
      required super.announcements,
      required this.quizzes,
      required this.assignments,
      required this.compensationLectures});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'quizzes': quizzes,
        'assignments': assignments,
        'compensationLectures': compensationLectures,
      };

  static Group fromJson(Map<String, dynamic> json) => Group(
        id: json['id'],
        courseId: json['courseId'],
        number: json['number'],
        lectures: (json['lectures'] as List<dynamic>)
            .map((lecture) => Lecture.fromJson(lecture))
            .toList(),
        students: (json['students'] as List<dynamic>).cast<String>(),
        announcements: (json['announcements'] as List<dynamic>).cast<String>(),
        quizzes: (json['quizzes'] as List<dynamic>).cast<String>(),
        assignments: (json['assignments'] as List<dynamic>).cast<String>(),
        compensationLectures:
            (json['compensationLectures'] as List<dynamic>).cast<String>(),
      );
}
