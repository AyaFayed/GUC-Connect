import 'package:guc_scheduling_app/models/events/event_model.dart';

class Assignment extends Event {
  DateTime deadline;

  Assignment(
      {required super.id,
      required super.instructorId,
      required super.courseId,
      required super.title,
      required super.description,
      required super.file,
      required super.groupIds,
      required this.deadline});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'deadline': deadline.millisecondsSinceEpoch,
      };

  static Map<String, dynamic> toJsonUpdate(
          String title, String description, String? file, DateTime deadline) =>
      {
        ...Event.toJsonUpdate(title, description, file),
        'deadline': deadline.millisecondsSinceEpoch,
      };

  static Assignment fromJson(Map<String, dynamic> json) => Assignment(
      id: json['id'],
      instructorId: json['instructorId'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      file: json['file'],
      groupIds: (json['groupIds'] as List<dynamic>).cast<String>(),
      deadline: DateTime.fromMillisecondsSinceEpoch(json['deadline']));
}
