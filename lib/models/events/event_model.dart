import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class Event {
  String id;
  String instructorId;
  String courseId;
  List<String> groupIds;
  String title;
  String description;
  String? file;

  Event(
      {required this.id,
      required this.instructorId,
      required this.courseId,
      required this.groupIds,
      required this.title,
      required this.description,
      required this.file});

  Map<String, dynamic> toJson() => {
        'id': id,
        'instructorId': instructorId,
        'courseId': courseId,
        'groupIds': groupIds,
        'title': title,
        'description': description,
        'file': file
      };

  static Map<String, dynamic> toJsonUpdate(
          String title, String description, String? file) =>
      {
        'title': title,
        'description': description,
        'file': file,
      };

  static Event fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        instructorId: json['instructorId'],
        courseId: json['courseId'],
        groupIds: (json['groupIds'] as List<dynamic>).cast<String>(),
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
  String? createdAt;

  DisplayEvent(
      {required this.id,
      required this.eventType,
      required this.title,
      required this.subtitle,
      required this.description,
      required this.file,
      this.createdAt});

  static Future<DisplayEvent> fromAnnouncement(
      Announcement announcement) async {
    UserController userController = UserController();
    UserType userType =
        await userController.getUserType(announcement.instructorId) ??
            UserType.student;
    String instructorName =
        await userController.getUserName(announcement.instructorId);
    return DisplayEvent(
        id: announcement.id,
        eventType: EventType.announcement,
        title: formatName(instructorName, userType),
        subtitle: announcement.title,
        description: announcement.description,
        file: announcement.file,
        createdAt: formatDate(announcement.createdAt));
  }

  static DisplayEvent fromAssignment(Assignment assignment) {
    return DisplayEvent(
        id: assignment.id,
        eventType: EventType.assignment,
        title: assignment.title,
        subtitle: 'Deadline ${formatDate(assignment.deadline)}',
        description: assignment.description,
        file: assignment.file);
  }

  static DisplayEvent fromScheduledEvent(ScheduledEvent scheduledEvent) {
    return DisplayEvent(
        id: scheduledEvent.id,
        eventType: scheduledEvent.type,
        title: scheduledEvent.title,
        subtitle: formatDateRange(scheduledEvent.start, scheduledEvent.end),
        description: scheduledEvent.description,
        file: scheduledEvent.file);
  }
}

class CalendarEvent {
  DateTime date;
  DisplayEvent event;
  String courseName;
  String courseId;
  CalendarEvent(
      {required this.date,
      required this.courseName,
      required this.courseId,
      required this.event});
}
