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
      required super.notes,
      required super.files,
      required this.groups,
      required this.start,
      required this.end});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'creator': creator,
        'course': course,
        'title': title,
        'notes': notes,
        'files': files,
        'groups': groups,
        'start': start,
        'end': end,
      };

  static Quiz fromJson(Map<String, dynamic> json) => Quiz(
      id: json['id'],
      creator: json['creator'],
      course: json['course'],
      title: json['title'],
      notes: json['notes'],
      files: (json['files'] as List<dynamic>).cast<String>(),
      groups: (json['groups'] as List<dynamic>).cast<String>(),
      start: DateTime.parse(json['start'].toString()),
      end: DateTime.parse(json['end'].toString()));
}
