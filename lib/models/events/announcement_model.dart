import 'package:guc_scheduling_app/models/events/event_model.dart';

class Announcement extends Event {
  DateTime createdAt;

  Announcement(
      {required super.id,
      required super.instructorId,
      required super.courseId,
      required super.groupIds,
      required super.title,
      required super.description,
      required super.file,
      required this.createdAt});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Announcement fromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'],
      instructorId: json['instructorId'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      groupIds: (json['groupIds'] as List<dynamic>).cast<String>(),
      file: json['file'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']));
}
