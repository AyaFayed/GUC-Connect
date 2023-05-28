import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/reads/assignment_reads.dart';
import 'package:guc_scheduling_app/database/reads/course_reads.dart';
import 'package:guc_scheduling_app/database/reads/group_reads.dart';
import 'package:guc_scheduling_app/database/reads/scheduled_event_reads.dart';
import 'package:guc_scheduling_app/database/reads/user_reads.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

import '../../models/events/assignment_model.dart';

class CalendarEventsController {
  final UserController _user = UserController();
  final UserReads _userReads = UserReads();
  final AssignmentReads _assignmentReads = AssignmentReads();
  final ScheduledEventReads _scheduledEventReads = ScheduledEventReads();
  final CourseReads _courseReads = CourseReads();
  final GroupReads _groupReads = GroupReads();

  Future<Map<DateTime, List<CalendarEvent>>> getMyCalendarEvents() async {
    List<Future<CalendarEvent>> calendarEvents = [];

    List<Assignment> assignments = [];
    List<ScheduledEvent> scheduledEvents = [];

    UserModel? currentUser = await _user.getCurrentUser();

    if (currentUser != null) {
      if (currentUser.type == UserType.student) {
        List<Group> groups =
            await _groupReads.getAllStudentGroups(currentUser.id);
        for (Group group in groups) {
          assignments
              .addAll(await _assignmentReads.getGroupAssignments(group.id));
          scheduledEvents.addAll(await _scheduledEventReads
              .getGroupScheduledEvents(group.id, group.courseId));
        }
      } else {
        assignments =
            await _assignmentReads.getAllInstructorAssignments(currentUser.id);
        scheduledEvents = await _scheduledEventReads
            .getAllInstructorScheduledEvents(currentUser.id);
      }
    }

    calendarEvents.addAll(assignments.map((assignment) async {
      Course? course = await _courseReads.getCourse(assignment.courseId);
      return CalendarEvent(
          date: DateTime(assignment.deadline.year, assignment.deadline.month,
              assignment.deadline.day),
          event: DisplayEvent.fromAssignment(assignment),
          courseId: assignment.courseId,
          courseName: course?.name ?? '');
    }).toList());

    calendarEvents.addAll(scheduledEvents.map((scheduledEvent) async {
      Course? course = await _courseReads.getCourse(scheduledEvent.courseId);
      return CalendarEvent(
          date: DateTime(scheduledEvent.start.year, scheduledEvent.start.month,
              scheduledEvent.start.day),
          event: DisplayEvent.fromScheduledEvent(scheduledEvent),
          courseId: scheduledEvent.courseId,
          courseName: course?.name ?? '');
    }).toList());

    List<CalendarEvent> events = await Future.wait(calendarEvents);
    Map<DateTime, List<CalendarEvent>> eventsMap = {};
    for (CalendarEvent event in events) {
      if (eventsMap[event.date] != null) {
        eventsMap[event.date]?.add(event);
      } else {
        eventsMap[event.date] = [event];
      }
    }

    return eventsMap;
  }

  Future<Map<DateTime, List<CourseCalendarEvent>>> getGroupCalendarEvents(
      List<String> groupIds) async {
    List<Future<CourseCalendarEvent>> calendarEvents = [];

    Map<Assignment, int> assignments = {};
    Map<ScheduledEvent, int> scheduledEvents = {};

    List<String> studentIds = await _groupReads.getGroupsStudentIds(groupIds);

    for (String studentId in studentIds) {
      UserModel? student = await _userReads.getUser(studentId);

      if (student != null) {
        List<Group> groups = await _groupReads.getAllStudentGroups(student.id);
        for (Group group in groups) {
          List<Assignment> studentAssignments =
              await _assignmentReads.getGroupAssignments(group.id);
          List<ScheduledEvent> studentScheduledEvents =
              await _scheduledEventReads.getGroupScheduledEvents(
                  group.id, group.courseId);

          for (Assignment assignment in studentAssignments) {
            assignments.update(assignment, (value) => value + 1,
                ifAbsent: () => 1);
          }

          for (ScheduledEvent scheduledEvent in studentScheduledEvents) {
            scheduledEvents.update(scheduledEvent, (value) => value + 1,
                ifAbsent: () => 1);
          }
        }
      }
    }
    calendarEvents.addAll(assignments.entries.map((assignment) async {
      Course? course = await _courseReads.getCourse(assignment.key.courseId);
      return CourseCalendarEvent(
          date: DateTime(assignment.key.deadline.year,
              assignment.key.deadline.month, assignment.key.deadline.day),
          event: DisplayEvent.fromAssignment(assignment.key),
          stdentsCount: assignment.value,
          courseId: assignment.key.courseId,
          courseName: course?.name ?? '');
    }).toList());

    calendarEvents.addAll(scheduledEvents.entries.map((scheduledEvent) async {
      Course? course =
          await _courseReads.getCourse(scheduledEvent.key.courseId);
      return CourseCalendarEvent(
          date: DateTime(scheduledEvent.key.start.year,
              scheduledEvent.key.start.month, scheduledEvent.key.start.day),
          event: DisplayEvent.fromScheduledEvent(scheduledEvent.key),
          stdentsCount: scheduledEvent.value,
          courseId: scheduledEvent.key.courseId,
          courseName: course?.name ?? '');
    }).toList());

    List<CourseCalendarEvent> events = await Future.wait(calendarEvents);
    Map<DateTime, List<CourseCalendarEvent>> eventsMap = {};
    for (CourseCalendarEvent event in events) {
      if (eventsMap[event.date] != null) {
        eventsMap[event.date]?.add(event);
      } else {
        eventsMap[event.date] = [event];
      }
    }

    return eventsMap;
  }
}
