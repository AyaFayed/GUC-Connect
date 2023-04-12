import 'package:guc_scheduling_app/models/events/event_model.dart';

class Assignment extends Event {
  List<String> groups;
  DateTime deadline;

  Assignment(
      {required super.id,
      required super.creator,
      required super.course,
      required super.title,
      required super.notes,
      required super.files,
      required this.groups,
      required this.deadline});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'creator': creator,
        'course': course,
        'title': title,
        'notes': notes,
        'files': files,
        'groups': groups,
        'deadline': deadline.millisecondsSinceEpoch,
      };

  static Assignment fromJson(Map<String, dynamic> json) => Assignment(
      id: json['id'],
      creator: json['creator'],
      course: json['course'],
      title: json['title'],
      notes: json['notes'],
      files: (json['files'] as List<dynamic>).cast<String>(),
      groups: (json['groups'] as List<dynamic>).cast<String>(),
      deadline: DateTime.fromMillisecondsSinceEpoch(json['dealine']));
}
