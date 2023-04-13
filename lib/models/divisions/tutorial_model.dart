import 'package:guc_scheduling_app/models/divisions/division_model.dart';

class Tutorial extends Division {
  List<String> compensationTutorials;

  Tutorial(
      {required super.id,
      required super.courseId,
      required super.number,
      required super.lectures,
      required super.students,
      required super.announcements,
      required this.compensationTutorials});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'compensationTutorials': compensationTutorials,
      };

  static Tutorial fromJson(Map<String, dynamic> json) => Tutorial(
        id: json['id'],
        courseId: json['courseId'],
        number: json['number'],
        lectures: (json['lectures'] as List<dynamic>)
            .map((lecture) => Lecture.fromJson(lecture))
            .toList(),
        students: (json['students'] as List<dynamic>).cast<String>(),
        announcements: (json['announcements'] as List<dynamic>).cast<String>(),
        compensationTutorials:
            (json['compensationTutorials'] as List<dynamic>).cast<String>(),
      );
}
