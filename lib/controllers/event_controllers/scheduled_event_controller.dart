import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/controllers/notification_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/database/reads/assignment_reads.dart';
import 'package:guc_scheduling_app/database/reads/group_reads.dart';
import 'package:guc_scheduling_app/database/reads/scheduled_event_reads.dart';
import 'package:guc_scheduling_app/database/writes/assignment_writes.dart';
import 'package:guc_scheduling_app/database/writes/scheduled_event_writes.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class ScheduledEventsController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _user = UserController();
  final NotificationController _notificationController =
      NotificationController();
  final EventsControllerHelper _helper = EventsControllerHelper();

  final GroupReads _groupReads = GroupReads();
  final ScheduledEventWrites _scheduledEventWrites = ScheduledEventWrites();
  final ScheduledEventReads _scheduledEventReads = ScheduledEventReads();
  final AssignmentWrites _assignmentWrites = AssignmentWrites();
  final AssignmentReads _assignmentReads = AssignmentReads();

  Future<bool> isConflicting(List<ScheduledEvent> scheduledEvents,
      DateTime start, DateTime end) async {
    for (ScheduledEvent scheduledEvent in scheduledEvents) {
      DateTime startGap = start.subtract(const Duration(minutes: 15));
      DateTime endGap = start.add(const Duration(minutes: 15));
      if (scheduledEvent.end.isAfter(startGap) &&
          scheduledEvent.end.isBefore(endGap)) {
        return true;
      }
      if (scheduledEvent.start.isAfter(startGap) &&
          scheduledEvent.start.isBefore(endGap)) {
        return true;
      }
    }

    return false;
  }

  Future<bool> isConflictingForStudent(
    String studentId,
    DateTime start,
    DateTime end,
    String? excludedEventId,
  ) async {
    List<Group> groups = await _groupReads.getAllStudentGroups(studentId);
    List<Future<bool>> conflicts = [];
    for (Group group in groups) {
      List<ScheduledEvent> scheduledEvents = await _scheduledEventReads
          .getGroupScheduledEvents(group.id, group.courseId);

      scheduledEvents.removeWhere(
          (scheduledEvent) => scheduledEvent.id == excludedEventId);

      conflicts.add(isConflicting(scheduledEvents, start, end));
    }
    List<bool> hasConflicts = await Future.wait(conflicts);
    return hasConflicts.contains(true);
  }

  Future<int> canScheduleGroups(
    List<String> groupIds,
    DateTime start,
    DateTime end,
    String? excludedEventId,
  ) async {
    List<Future<bool>> hasConflicts = [];
    List<String> studentIds = await _groupReads.getGroupsStudentIds(groupIds);
    for (String studentId in studentIds) {
      hasConflicts
          .add(isConflictingForStudent(studentId, start, end, excludedEventId));
    }
    int conflictCount = 0;
    List<bool> conflicts = await Future.wait(hasConflicts);
    for (bool conflict in conflicts) {
      if (conflict == true) {
        conflictCount++;
      }
    }

    return conflictCount;
  }

  Future scheduleEvent(
      String courseId,
      String courseName,
      String title,
      String description,
      String? file,
      List<String> groupIds,
      DateTime start,
      DateTime end,
      EventType type) async {
    bool isCurrentUserInstructor = await _user.isCurrentUserInstructor();

    if (isCurrentUserInstructor) {
      final docScheduledEvent = DatabaseReferences.scheduledEvents.doc();

      final scheduledEvent = ScheduledEvent(
          id: docScheduledEvent.id,
          instructorId: _auth.currentUser?.uid ?? '',
          courseId: courseId,
          title: title,
          description: description,
          file: file,
          groupIds: groupIds,
          start: start,
          end: end,
          type: type);

      final json = scheduledEvent.toJson();

      await docScheduledEvent.set(json);
    }
  }

  Future editEvent(
      String courseName,
      EventType eventType,
      String eventId,
      String title,
      String description,
      String? file,
      DateTime start,
      DateTime? end) async {
    bool isCurrentUserInstructor = await _user.isCurrentUserInstructor();

    if (!isCurrentUserInstructor) return;

    List<String> studentIds = [];

    switch (eventType) {
      case EventType.announcement:
        break;
      case EventType.assignment:
        await _assignmentWrites.updateAssignment(
            eventId, title, description, file, start);

        Assignment? assignment = await _assignmentReads.getAssignment(eventId);
        if (assignment != null) {
          studentIds =
              await _groupReads.getGroupsStudentIds(assignment.groupIds);
        }
        break;
      case EventType.quiz:
      case EventType.compensationLecture:
      case EventType.compensationTutorial:
        await _scheduledEventWrites.updateScheduledEvent(
            eventId, title, description, file, start, end ?? start);

        ScheduledEvent? scheduledEvent =
            await _scheduledEventReads.getScheduledEvent(eventId);

        if (scheduledEvent != null) {
          studentIds =
              await _groupReads.getGroupsStudentIds(scheduledEvent.groupIds);
        }
        break;
    }

    await _user.notifyUsers(studentIds, courseName, '$title was updated.');

    await _notificationController.createNotification(
        studentIds,
        courseName,
        courseName,
        '$title was updated.',
        eventId,
        getNotificationTypeFromEventType(eventType));
  }

  Future<int> canEditScheduledEvent(
      EventType eventType, String eventId, DateTime start, DateTime end) async {
    switch (eventType) {
      case EventType.announcement:
        return 0;
      case EventType.assignment:
        return 0;
      case EventType.quiz:
      case EventType.compensationLecture:
      case EventType.compensationTutorial:
        ScheduledEvent? scheduledEvent =
            await _scheduledEventReads.getScheduledEvent(eventId);
        int conflicts = await canScheduleGroups(
            scheduledEvent?.groupIds ?? [], start, end, eventId);
        return conflicts;
    }
  }

  Future deleteScheduledEvent(String courseName, String eventId) async {
    bool isCurrentUserInstructor = await _user.isCurrentUserInstructor();

    if (isCurrentUserInstructor) {
      ScheduledEvent? scheduledEvent =
          await _scheduledEventReads.getScheduledEvent(eventId);

      if (scheduledEvent != null) {
        await _helper.notifyGroupsAboutRemovedEvent(scheduledEvent.groupIds,
            courseName, '${scheduledEvent.title} was removed');

        await _scheduledEventWrites.deleteScheduledEvent(eventId);
      }
    }
  }

  Future<List<ScheduledEvent>> getMyScheduledEvents(
      String courseId, EventType eventType) async {
    if (_auth.currentUser == null) return [];
    List<ScheduledEvent> scheduledEvents =
        await _scheduledEventReads.getInstructorScheduledEvents(
            _auth.currentUser?.uid ?? '', courseId, eventType);

    scheduledEvents.sort(
        ((ScheduledEvent a, ScheduledEvent b) => a.start.compareTo(b.start)));

    return scheduledEvents;
  }

  Future<List<ScheduledEvent>> getGroupScheduledEvents(
      String groupId, EventType eventType) async {
    return await _scheduledEventReads.getGroupScheduledEventsWithType(
        groupId, eventType);
  }

  Future<List<ScheduledEvent>> getCourseScheduledEvents(
      String courseId, EventType eventType) async {
    if (_auth.currentUser == null) return [];

    Group? studentLectureGroup = await _groupReads.getStudentCourseLectureGroup(
        courseId, _auth.currentUser?.uid ?? '');
    Group? studentTutorialGroup = await _groupReads
        .getStudentCourseTutorialGroup(courseId, _auth.currentUser?.uid ?? '');

    List<ScheduledEvent> scheduledEvents = [];

    if (studentLectureGroup != null) {
      scheduledEvents.addAll(
          await getGroupScheduledEvents(studentLectureGroup.id, eventType));
    }

    if (studentTutorialGroup != null) {
      scheduledEvents.addAll(
          await getGroupScheduledEvents(studentTutorialGroup.id, eventType));
    }

    scheduledEvents.sort(
        ((ScheduledEvent a, ScheduledEvent b) => a.start.compareTo(b.start)));

    return scheduledEvents;
  }
}
