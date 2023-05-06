import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/database/reads/assignment_reads.dart';
import 'package:guc_scheduling_app/database/reads/group_reads.dart';
import 'package:guc_scheduling_app/database/writes/assignment_writes.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class AssignmentController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventsControllerHelper _helper = EventsControllerHelper();
  final UserController _user = UserController();

  final AssignmentReads _assignmentReads = AssignmentReads();
  final AssignmentWrites _assignmentWrites = AssignmentWrites();
  final GroupReads _groupReads = GroupReads();

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
      final docAssignment = DatabaseReferences.assignments.doc();

      final assignment = Assignment(
          id: docAssignment.id,
          instructorId: _auth.currentUser?.uid ?? '',
          courseId: courseId,
          title: title,
          description: description,
          file: file,
          groupIds: groupIds,
          deadline: deadline);

      final json = assignment.toJson();

      await docAssignment.set(json);

      await _helper.notifyGroupsAboutEvent(courseName, docAssignment.id,
          EventType.assignment, groupIds, courseName, title);
    }
  }

  Future<List<Assignment>> getGroupAssignments(String groupId) async {
    return await _assignmentReads.getGroupAssignments(groupId);
  }

  Future<List<Assignment>> getCourseAssignments(String courseId) async {
    if (_auth.currentUser == null) return [];

    Group? studentLectureGroup = await _groupReads.getStudentCourseLectureGroup(
        courseId, _auth.currentUser?.uid ?? '');

    List<Assignment> assignments = [];
    if (studentLectureGroup != null) {
      assignments.addAll(await getGroupAssignments(studentLectureGroup.id));
    }

    assignments.sort(
        ((Assignment a, Assignment b) => a.deadline.compareTo(b.deadline)));

    return assignments;
  }

  Future<List<Assignment>> getMyAssignments(String courseId) async {
    if (_auth.currentUser == null) return [];
    List<Assignment> assignments = await _assignmentReads
        .getInstructorAssignments(_auth.currentUser?.uid ?? '', courseId);
    assignments.sort(
        ((Assignment a, Assignment b) => a.deadline.compareTo(b.deadline)));
    return assignments;
  }

  Future deleteAssignment(String courseName, String assignmentId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      Assignment? assignment =
          await _assignmentReads.getAssignment(assignmentId);

      if (assignment != null) {
        await _helper.notifyGroupsAboutRemovedEvent(
            assignment.groupIds, courseName, '${assignment.title} was removed');

        await _assignmentWrites.deleteAssignment(assignmentId);
      }
    }
  }
}
