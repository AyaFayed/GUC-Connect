import 'package:guc_scheduling_app/models/events/event_model.dart';

class Quiz extends Event {
  List<String> groups;
  DateTime start;
  DateTime end;

  Quiz(
      {required super.id,
      required super.creator,
      required super.course,
      required super.title,
      required super.description,
      required super.files,
      required this.groups,
      required this.start,
      required this.end});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'groups': groups,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      };

  static Quiz fromJson(Map<String, dynamic> json) => Quiz(
      id: json['id'],
      creator: json['creator'],
      course: json['course'],
      title: json['title'],
      description: json['description'],
      files: (json['files'] as List<dynamic>).cast<String>(),
      groups: (json['groups'] as List<dynamic>).cast<String>(),
      start: DateTime.fromMillisecondsSinceEpoch(json['start']),
      end: DateTime.fromMillisecondsSinceEpoch(json['end']));
}
