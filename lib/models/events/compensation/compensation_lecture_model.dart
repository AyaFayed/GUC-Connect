import 'package:guc_scheduling_app/models/events/compensation/compensation_model.dart';

class CompensationLecture extends Compensation {
  List<String> groupIds;

  CompensationLecture({
    required super.id,
    required super.creatorId,
    required super.courseId,
    required super.title,
    required super.description,
    required super.file,
    required super.start,
    required super.end,
    required this.groupIds,
  });

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'groupIds': groupIds,
      };

  static CompensationLecture fromJson(Map<String, dynamic> json) =>
      CompensationLecture(
        id: json['id'],
        creatorId: json['creatorId'],
        courseId: json['courseId'],
        title: json['title'],
        description: json['description'],
        file: json['file'],
        start: DateTime.fromMillisecondsSinceEpoch(json['start']),
        end: DateTime.fromMillisecondsSinceEpoch(json['end']),
        groupIds: (json['groupIds'] as List<dynamic>).cast<String>(),
      );
}
