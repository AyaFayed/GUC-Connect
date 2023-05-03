import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class AssignmentController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventsControllerHelper _helper = EventsControllerHelper();
  final UserController _user = UserController();

  Future scheduleAssignment(
      String courseId,
      String courseName,
      String title,
      String description,
      String? file,
      List<String> groupIds,
      DateTime deadline) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      final docAssignment = Database.assignments.doc();

      final assignment = Assignment(
          id: docAssignment.id,
          creatorId: _auth.currentUser?.uid ?? '',
          courseId: courseId,
          title: title,
          description: description,
          file: file,
          groupIds: groupIds,
          deadline: deadline);

      final json = assignment.toJson();

      await docAssignment.set(json);

      await _helper.addEventToInstructor(
          courseId, docAssignment.id, EventType.assignments);

      await _helper.addEventInDivisions(
          courseName,
          docAssignment.id,
          EventType.assignments,
          DivisionType.groups,
          groupIds,
          courseName,
          title);
    }
  }

  Future<List<Assignment>> getGroupAssignments(String groupId) async {
    Group? group = await Database.getGroup(groupId);

    if (group != null) {
      return await Database.getAssignmentListFromIds(group.assignmentIds);
    } else {
      return [];
    }
  }

  Future<List<Assignment>> getAssignments(String courseId) async {
    Student? student = await Database.getStudent(_auth.currentUser?.uid ?? '');
    if (student != null) {
      for (StudentCourse course in student.courses) {
        if (course.id == courseId) {
          List<Assignment> assignments =
              await getGroupAssignments(course.group);
          assignments.sort(((Assignment a, Assignment b) =>
              a.deadline.compareTo(b.deadline)));
          return assignments;
        }
      }
    }
    return [];
  }

  Future<List<Assignment>> getMyAssignments(String courseId) async {
    List<Assignment> assignments = (await _helper.getEventsofInstructor(
            courseId, EventType.assignments) as List<dynamic>)
        .cast<Assignment>();
    assignments.sort(
        ((Assignment a, Assignment b) => a.deadline.compareTo(b.deadline)));
    return assignments;
  }

  static Future<List<String>> editAssignment(String assignmentId, String title,
      String description, String? file, DateTime deadline) async {
    await Database.assignments
        .doc(assignmentId)
        .update(Assignment.toJsonUpdate(title, description, file, deadline));

    Assignment? assignment = await Database.getAssignment(assignmentId);
    List<String> studentIds = [];

    if (assignment != null) {
      studentIds = await Database.getDivisionsStudentIds(
          assignment.groupIds, DivisionType.groups);
    }

    return studentIds;
  }

  Future deleteAssignment(String courseName, String assignmentId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      Assignment? assignment = await Database.getAssignment(assignmentId);

      if (assignment != null) {
        await _helper.removeEventFromDivisions(
            assignmentId,
            EventType.assignments,
            DivisionType.groups,
            assignment.groupIds,
            courseName,
            '${assignment.title} was removed');
        await _helper.removeEventFromInstructor(
            assignment.courseId, assignmentId, EventType.assignments);

        await Database.assignments.doc(assignmentId).delete();
      }
    }
  }
}
