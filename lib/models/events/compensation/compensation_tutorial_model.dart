import 'package:guc_scheduling_app/models/events/compensation/compensation_model.dart';

class CompensationTutorial extends Compensation {
  List<String> tutorialIds;
  CompensationTutorial({
    required super.id,
    required super.creatorId,
    required super.courseId,
    required super.title,
    required super.description,
    required super.file,
    required super.start,
    required super.end,
    required this.tutorialIds,
  });

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'tutorialIds': tutorialIds,
      };

  static CompensationTutorial fromJson(Map<String, dynamic> json) =>
      CompensationTutorial(
        id: json['id'],
        creatorId: json['creatorId'],
        courseId: json['courseId'],
        title: json['title'],
        description: json['description'],
        file: json['file'],
        start: DateTime.fromMillisecondsSinceEpoch(json['start']),
        end: DateTime.fromMillisecondsSinceEpoch(json['end']),
        tutorialIds: (json['tutorialIds'] as List<dynamic>).cast<String>(),
      );
}
