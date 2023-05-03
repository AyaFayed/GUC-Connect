import 'package:guc_scheduling_app/models/divisions/division_model.dart';

class Group extends Division {
  List<String> quizIds;
  List<String> assignmentIds;
  List<String> compensationLectureIds;

  Group(
      {required super.id,
      required super.courseId,
      required super.number,
      required super.lectures,
      required super.studentIds,
      required super.announcementIds,
      required this.quizIds,
      required this.assignmentIds,
      required this.compensationLectureIds});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'quizIds': quizIds,
        'assignmentIds': assignmentIds,
        'compensationLectureIds': compensationLectureIds,
      };

  static Group fromJson(Map<String, dynamic> json) => Group(
        id: json['id'],
        courseId: json['courseId'],
        number: json['number'],
        lectures: (json['lectures'] as List<dynamic>)
            .map((lecture) => Lecture.fromJson(lecture))
            .toList(),
        studentIds: (json['studentIds'] as List<dynamic>).cast<String>(),
        announcementIds:
            (json['announcementIds'] as List<dynamic>).cast<String>(),
        quizIds: (json['quizIds'] as List<dynamic>).cast<String>(),
        assignmentIds: (json['assignmentIds'] as List<dynamic>).cast<String>(),
        compensationLectureIds:
            (json['compensationLectureIds'] as List<dynamic>).cast<String>(),
      );
}
