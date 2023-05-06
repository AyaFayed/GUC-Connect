import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class ScheduledEvent extends Event {
  DateTime start;
  DateTime end;
  EventType type;

  ScheduledEvent(
      {required super.id,
      required super.instructorId,
      required super.courseId,
      required super.title,
      required super.description,
      required super.file,
      required super.groupIds,
      required this.start,
      required this.end,
      required this.type});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'type': type.name,
      };

  static Map<String, dynamic> toJsonUpdate(String title, String description,
          String? file, DateTime start, DateTime end) =>
      {
        ...Event.toJsonUpdate(title, description, file),
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      };

  static ScheduledEvent fromJson(Map<String, dynamic> json) => ScheduledEvent(
      id: json['id'],
      instructorId: json['instructorId'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      file: json['file'],
      groupIds: (json['groupIds'] as List<dynamic>).cast<String>(),
      start: DateTime.fromMillisecondsSinceEpoch(json['start']),
      end: DateTime.fromMillisecondsSinceEpoch(json['end']),
      type: getEventTypeFromString(json['type']));
}
