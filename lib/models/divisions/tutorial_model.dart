import 'package:guc_scheduling_app/models/divisions/division_model.dart';

class Tutorial extends Division {
  List<String> compensationTutorialIds;

  Tutorial(
      {required super.id,
      required super.courseId,
      required super.number,
      required super.lectures,
      required super.studentIds,
      required super.announcementIds,
      required this.compensationTutorialIds});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'compensationTutorialIds': compensationTutorialIds,
      };

  static Tutorial fromJson(Map<String, dynamic> json) => Tutorial(
        id: json['id'],
        courseId: json['courseId'],
        number: json['number'],
        lectures: (json['lectures'] as List<dynamic>)
            .map((lecture) => Lecture.fromJson(lecture))
            .toList(),
        studentIds: (json['studentIds'] as List<dynamic>).cast<String>(),
        announcementIds:
            (json['announcementIds'] as List<dynamic>).cast<String>(),
        compensationTutorialIds:
            (json['compensationTutorialIds'] as List<dynamic>).cast<String>(),
      );
}
