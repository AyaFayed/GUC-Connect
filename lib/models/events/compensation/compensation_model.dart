import 'package:guc_scheduling_app/models/events/event_model.dart';

class Compensation extends Event {
  DateTime start;
  DateTime end;

  Compensation(
      {required super.id,
      required super.creator,
      required super.course,
      required super.title,
      required super.notes,
      required super.files,
      required this.start,
      required this.end});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      };

  static Compensation fromJson(Map<String, dynamic> json) => Compensation(
      id: json['id'],
      creator: json['creator'],
      course: json['course'],
      title: json['title'],
      notes: json['notes'],
      files: (json['files'] as List<dynamic>).cast<String>(),
      start: DateTime.fromMillisecondsSinceEpoch(json['start']),
      end: DateTime.fromMillisecondsSinceEpoch(json['end']));
}
