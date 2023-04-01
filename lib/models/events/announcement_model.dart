import 'package:guc_scheduling_app/models/events/event_model.dart';

class Announcement extends Event {
  List<String> groups;
  List<String> tutorials;

  Announcement({
    required super.id,
    required super.creator,
    required super.course,
    required super.title,
    required super.notes,
    required super.files,
    required this.groups,
    required this.tutorials,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'creator': creator,
        'course': course,
        'title': title,
        'notes': notes,
        'files': files,
        'groups': groups,
        'tutorials': tutorials
      };

  static Announcement fromJson(Map<String, dynamic> json) => Announcement(
        id: json['id'],
        creator: json['creator'],
        course: json['course'],
        title: json['title'],
        notes: json['notes'],
        groups: (json['groups'] as List<dynamic>).cast<String>(),
        tutorials: (json['tutorials'] as List<dynamic>).cast<String>(),
        files: (json['files'] as List<dynamic>).cast<String>(),
      );
}
