import 'package:guc_scheduling_app/models/events/compensation/compensation_model.dart';

class CompensationLecture extends Compensation {
  List<String> groups;

  CompensationLecture({
    required super.id,
    required super.creator,
    required super.course,
    required super.title,
    required super.notes,
    required super.files,
    required super.start,
    required super.end,
    required this.groups,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'creator': creator,
        'course': course,
        'title': title,
        'notes': notes,
        'files': files,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'groups': groups,
      };

  static CompensationLecture fromJson(Map<String, dynamic> json) =>
      CompensationLecture(
        id: json['id'],
        creator: json['creator'],
        course: json['course'],
        title: json['title'],
        notes: json['notes'],
        files: (json['files'] as List<dynamic>).cast<String>(),
        start: DateTime.fromMillisecondsSinceEpoch(json['start']),
        end: DateTime.fromMillisecondsSinceEpoch(json['end']),
        groups: (json['groups'] as List<dynamic>).cast<String>(),
      );
}
