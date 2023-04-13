import 'package:guc_scheduling_app/models/events/compensation/compensation_model.dart';

class CompensationTutorial extends Compensation {
  List<String> tutorials;
  CompensationTutorial({
    required super.id,
    required super.creator,
    required super.course,
    required super.title,
    required super.notes,
    required super.files,
    required super.start,
    required super.end,
    required this.tutorials,
  });

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'tutorials': tutorials,
      };

  static CompensationTutorial fromJson(Map<String, dynamic> json) =>
      CompensationTutorial(
        id: json['id'],
        creator: json['creator'],
        course: json['course'],
        title: json['title'],
        notes: json['notes'],
        files: (json['files'] as List<dynamic>).cast<String>(),
        start: DateTime.fromMillisecondsSinceEpoch(json['start']),
        end: DateTime.fromMillisecondsSinceEpoch(json['end']),
        tutorials: (json['tutorials'] as List<dynamic>).cast<String>(),
      );
}
