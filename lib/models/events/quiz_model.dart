import 'package:guc_scheduling_app/models/events/event_model.dart';

class Quiz extends Event {
  List<String> groupIds;
  DateTime start;
  DateTime end;

  Quiz(
      {required super.id,
      required super.creatorId,
      required super.courseId,
      required super.title,
      required super.description,
      required super.file,
      required this.groupIds,
      required this.start,
      required this.end});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'groupIds': groupIds,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      };

  static Map<String, dynamic> toJsonUpdate(String title, String description,
          String? file, DateTime start, DateTime end) =>
      {
        ...Event.toJsonUpdate(title, description, file),
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      };

  static Quiz fromJson(Map<String, dynamic> json) => Quiz(
      id: json['id'],
      creatorId: json['creatorId'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      file: json['file'],
      groupIds: (json['groupIds'] as List<dynamic>).cast<String>(),
      start: DateTime.fromMillisecondsSinceEpoch(json['start']),
      end: DateTime.fromMillisecondsSinceEpoch(json['end']));
}
