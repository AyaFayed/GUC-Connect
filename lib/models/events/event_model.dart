import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class Event {
  String id;
  String creatorId;
  String courseId;
  String title;
  String description;
  String? file;

  Event(
      {required this.id,
      required this.creatorId,
      required this.courseId,
      required this.title,
      required this.description,
      required this.file});

  Map<String, dynamic> toJson() => {
        'id': id,
        'creatorId': creatorId,
        'courseId': courseId,
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
        creatorId: json['creatorId'],
        courseId: json['courseId'],
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

  static Future<DisplayEvent> fromAnnouncement(
      Announcement announcement) async {
    UserController userController = UserController();
    UserType userType =
        await userController.getUserType(announcement.creatorId);
    String instructorName =
        await userController.getUserName(announcement.creatorId);
    return DisplayEvent(
        id: announcement.id,
        eventType: EventType.announcements,
        title: formatName(instructorName, userType),
        subtitle: announcement.title,
        description: announcement.description,
        file: announcement.file);
  }

  static DisplayEvent fromAssignment(Assignment assignment) {
    return DisplayEvent(
        id: assignment.id,
        eventType: EventType.assignments,
        title: assignment.title,
        subtitle: 'Deadline ${formatDate(assignment.deadline)}',
        description: assignment.description,
        file: assignment.file);
  }

  static DisplayEvent fromQuiz(Quiz quiz) {
    return DisplayEvent(
        id: quiz.id,
        eventType: EventType.quizzes,
        title: quiz.title,
        subtitle: formatDateRange(quiz.start, quiz.end),
        description: quiz.description,
        file: quiz.file);
  }

  static DisplayEvent fromCompensationLecture(
      CompensationLecture compensationLecture) {
    return DisplayEvent(
        id: compensationLecture.id,
        eventType: EventType.compensationLectures,
        title: compensationLecture.title,
        subtitle:
            formatDateRange(compensationLecture.start, compensationLecture.end),
        description: compensationLecture.description,
        file: compensationLecture.file);
  }

  static DisplayEvent fromCompensationTutorial(
      CompensationTutorial compensationTutorial) {
    return DisplayEvent(
        id: compensationTutorial.id,
        eventType: EventType.compensationTutorials,
        title: compensationTutorial.title,
        subtitle: formatDateRange(
            compensationTutorial.start, compensationTutorial.end),
        description: compensationTutorial.description,
        file: compensationTutorial.file);
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
