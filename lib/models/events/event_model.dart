import 'package:guc_scheduling_app/shared/constants.dart';

class Event {
  String id;
  String creator;
  String course;
  String title;
  String description;
  String? file;

  Event(
      {required this.id,
      required this.creator,
      required this.course,
      required this.title,
      required this.description,
      required this.file});

  Map<String, dynamic> toJson() => {
        'id': id,
        'creator': creator,
        'course': course,
        'title': title,
        'description': description,
        'file': file
      };

  static Event fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        creator: json['creator'],
        course: json['course'],
        title: json['title'],
        description: json['description'],
        file: json['file'],
      );
}

class DisplayEvent {
  String id;
  EventType eventType;
  String title;
  String subtitle;
  String description;
  String? file;

  DisplayEvent(
      {required this.id,
      required this.eventType,
      required this.title,
      required this.subtitle,
      required this.description,
      required this.file});
}
