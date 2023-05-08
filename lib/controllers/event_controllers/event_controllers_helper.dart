import 'package:guc_scheduling_app/controllers/notification_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/reads/assignment_reads.dart';
import 'package:guc_scheduling_app/database/reads/course_reads.dart';
import 'package:guc_scheduling_app/database/reads/group_reads.dart';
import 'package:guc_scheduling_app/database/reads/scheduled_event_reads.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

import '../../models/events/assignment_model.dart';

class EventsControllerHelper {
  final UserController _user = UserController();
  final NotificationController _notificationController =
      NotificationController();

  final AssignmentReads _assignmentReads = AssignmentReads();
  final GroupReads _groupReads = GroupReads();
  final ScheduledEventReads _scheduledEventReads = ScheduledEventReads();
  final CourseReads _courseReads = CourseReads();

  Future notifyGroupsAboutEvent(
      String courseName,
      String eventId,
      EventType eventType,
      List<String> groupIds,
      String notificationTitle,
      String notificationBody) async {
    List<String> studentIds = await _groupReads.getGroupsStudentIds(groupIds);

    await _user.notifyUsers(studentIds, notificationTitle, notificationBody);

    // await sendReminders(studentIds, eventId, 2);

    await _notificationController.createNotification(
        studentIds,
        courseName,
        notificationTitle,
        notificationBody,
        eventId,
        getNotificationTypeFromEventType(eventType));
  }

  Future notifyGroupsAboutRemovedEvent(List<String> groupIds,
      String notificationTitle, String notificationBody) async {
    List<String> studentIds = await _groupReads.getGroupsStudentIds(groupIds);

    await _user.notifyUsers(studentIds, notificationTitle, notificationBody);
  }

  Future<List<CalendarEvent>> getCalendarEventsFromList(String courseName,
      String courseId, List<String> eventIds, EventType eventType) async {
    switch (eventType) {
      case EventType.announcement:
        return [];
      case EventType.assignment:
        List<Assignment> assignments =
            await _assignmentReads.getAssignmentListFromIds(eventIds);
        return assignments
            .map((assignment) => CalendarEvent(
                date: DateTime(assignment.deadline.year,
                    assignment.deadline.month, assignment.deadline.day),
                event: DisplayEvent.fromAssignment(assignment),
                courseId: courseId,
                courseName: courseName))
            .toList();
      case EventType.quiz:
      case EventType.compensationLecture:
      case EventType.compensationTutorial:
        List<ScheduledEvent> scheduledEvents =
            await _scheduledEventReads.getScheduledEventListFromIds(eventIds);
        return scheduledEvents
            .map((scheduledEvent) => CalendarEvent(
                date: DateTime(scheduledEvent.start.year,
                    scheduledEvent.start.month, scheduledEvent.start.day),
                event: DisplayEvent.fromScheduledEvent(scheduledEvent),
                courseId: courseId,
                courseName: courseName))
            .toList();
    }
  }

  Future setReminder(String eventId, int days, int hours) async {
    ScheduledEvent? event =
        await _scheduledEventReads.getScheduledEvent(eventId);
    if (event != null) {
      DateTime reminderDateTime =
          event.start.subtract(Duration(days: days, hours: hours));
      Course? course = await _courseReads.getCourse(event.courseId);
      await _user.remindCurrentUser(course?.name ?? 'Reminder',
          'Reminder for ${event.title}', reminderDateTime);
    }
  }

  Future sendReminders(
      List<String> studentIds, String eventId, int days) async {
    ScheduledEvent? event =
        await _scheduledEventReads.getScheduledEvent(eventId);
    if (event != null) {
      DateTime reminderDateTime = event.start.subtract(Duration(days: days));
      Course? course = await _courseReads.getCourse(event.courseId);
      await _user.remindUsers(
          studentIds,
          course?.name ?? 'Reminder',
          'Reminder for ${event.title}',
          DateTime.now().add(Duration(minutes: 2)));
    }
  }
}
