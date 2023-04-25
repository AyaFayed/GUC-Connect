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

  Future scheduleAssignment(String courseId, String title, String description,
      String? file, List<String> groupIds, DateTime deadline) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      final docAssignment = Database.assignments.doc();

      final quiz = Assignment(
          id: docAssignment.id,
          creator: _auth.currentUser?.uid ?? '',
          course: courseId,
          title: title,
          description: description,
          file: file,
          groups: groupIds,
          deadline: deadline);

      final json = quiz.toJson();

      await docAssignment.set(json);

      await _helper.addEventToInstructor(
          courseId, docAssignment.id, EventType.assignments);

      await _helper.addEventInDivisions(docAssignment.id, EventType.assignments,
          DivisionType.groups, groupIds);
    }
  }

  Future<List<Assignment>> getGroupAssignments(String groupId) async {
    Group? group = await Database.getGroup(groupId);

    if (group != null) {
      return (await _helper.getEventsFromList(
              group.assignments, EventType.assignments) as List<dynamic>)
          .cast<Assignment>();
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

  static Future editAssignment(String assignmentId, String title,
      String description, String? file, DateTime deadline) async {
    final docAssignment = Database.assignments.doc(assignmentId);

    await docAssignment
        .update(Assignment.toJsonUpdate(title, description, file, deadline));
  }

  Future deleteAssignment(String assignmentId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      Assignment? assignment = await Database.getAssignment(assignmentId);

      if (assignment != null) {
        await _helper.removeEventFromDivisions(assignmentId,
            EventType.assignments, DivisionType.groups, assignment.groups);
        await _helper.removeEventFromInstructor(
            assignment.course, assignmentId, EventType.assignments);

        await Database.assignments.doc(assignmentId).delete();
      }
    }
  }
}
