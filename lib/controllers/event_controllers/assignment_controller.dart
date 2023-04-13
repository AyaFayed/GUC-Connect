import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class AssignmentController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventsControllerHelper _helper = EventsControllerHelper();

  Future scheduleAssignment(String courseId, String title, String notes,
      List<String> files, List<String> groupIds, DateTime deadline) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.professor) {
        final docAssignment = _database.collection('assignments').doc();

        final quiz = Assignment(
            id: docAssignment.id,
            creator: _auth.currentUser?.uid ?? '',
            course: courseId,
            title: title,
            notes: notes,
            files: files,
            groups: groupIds,
            deadline: deadline);

        final json = quiz.toJson();

        await docAssignment.set(json);

        await _helper.addEventToInstructor(
            courseId, docAssignment.id, EventType.assignments);

        await _helper.addEventInDivisions(docAssignment.id,
            EventType.assignments, DivisionType.groups, groupIds);
      }
    }
  }

  Future<List<Assignment>> getGroupAssignments(String groupId) async {
    final docGroup = _database.collection('groups').doc(groupId);
    final groupSnapshot = await docGroup.get();

    if (groupSnapshot.exists) {
      final groupData = groupSnapshot.data();
      Group group = Group.fromJson(groupData!);

      return (await _helper.getEventsFromList(group.quizzes, EventType.quizzes)
              as List<dynamic>)
          .cast<Assignment>();
    } else {
      return [];
    }
  }

  Future<List<Assignment>> getAssignments(String courseId) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data();
      Student student = Student.fromJson(userData!);
      for (StudentCourse course in student.courses) {
        if (course.id == courseId) {
          return await getGroupAssignments(course.group);
        }
      }
    }
    return [];
  }
}
