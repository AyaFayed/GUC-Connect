import 'package:guc_scheduling_app/models/events/event_model.dart';

class Announcement extends Event {
  List<String> groupIds;
  List<String> tutorialIds;
  DateTime createdAt;

  Announcement(
      {required super.id,
      required super.creatorId,
      required super.courseId,
      required super.title,
      required super.description,
      required super.file,
      required this.groupIds,
      required this.tutorialIds,
      required this.createdAt});

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'groupIds': groupIds,
        'tutorialIds': tutorialIds,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Announcement fromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'],
      creatorId: json['creatorId'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      groupIds: (json['groupIds'] as List<dynamic>).cast<String>(),
      tutorialIds: (json['tutorialIds'] as List<dynamic>).cast<String>(),
      file: json['file'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']));
}
