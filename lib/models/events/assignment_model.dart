import 'package:guc_scheduling_app/models/events/event_model.dart';

class Assignment extends Event {
  List<String> groupIds;
  DateTime deadline;

  Assignment(
      {required super.id,
      required super.creatorId,
      required super.courseId,
      required super.title,
      required super.description,
      required super.file,
      required this.groupIds,
      required this.deadline});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'groupIds': groupIds,
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
      creatorId: json['creatorId'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      file: json['file'],
      groupIds: (json['groupIds'] as List<dynamic>).cast<String>(),
      deadline: DateTime.fromMillisecondsSinceEpoch(json['deadline']));
}
