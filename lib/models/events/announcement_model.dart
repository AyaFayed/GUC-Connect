import 'package:guc_scheduling_app/models/events/event_model.dart';

class Announcement extends Event {
  List<String> groups;
  List<String> tutorials;
  DateTime createdAt;

  Announcement(
      {required super.id,
      required super.creator,
      required super.course,
      required super.title,
      required super.description,
      required super.files,
      required this.groups,
      required this.tutorials,
      required this.createdAt});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'groups': groups,
        'tutorials': tutorials,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Announcement fromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'],
      creator: json['creator'],
      course: json['course'],
      title: json['title'],
      description: json['description'],
      groups: (json['groups'] as List<dynamic>).cast<String>(),
      tutorials: (json['tutorials'] as List<dynamic>).cast<String>(),
      files: (json['files'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']));
}
