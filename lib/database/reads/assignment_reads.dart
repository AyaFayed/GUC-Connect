import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';

class AssignmentReads {
  final CollectionReference<Map<String, dynamic>> _assignments =
      DatabaseReferences.assignments;

  Future<Assignment?> getAssignment(String assignmentId) async {
    final assignmentData = await DatabaseReferences.getDocumentData(
        DatabaseReferences.assignments, assignmentId);
    if (assignmentData != null) {
      Assignment assignment = Assignment.fromJson(assignmentData);
      return assignment;
    }
    return null;
  }

  Future<List<Assignment>> getAssignmentListFromIds(
      List<String> eventIds) async {
    QuerySnapshot querySnapshot =
        await _assignments.where('id', whereIn: eventIds).get();

    List<Assignment> assignments = querySnapshot.docs
        .map((doc) => Assignment.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return assignments;
  }

  Future<List<Assignment>> getAllAssignments() async {
    QuerySnapshot querySnapshot = await _assignments.get();

    List<Assignment> allAssignments = querySnapshot.docs
        .map((doc) => Assignment.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allAssignments;
  }

  Future<List<Assignment>> getInstructorAssignments(
      String instructorId, String courseId) async {
    QuerySnapshot querySnapshot = await _assignments
        .where('courseId', isEqualTo: courseId)
        .where('instructorId', isEqualTo: instructorId)
        .get();

    List<Assignment> assignments = querySnapshot.docs
        .map((doc) => Assignment.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return assignments;
  }

  Future<List<Assignment>> getAllInstructorAssignments(
      String instructorId) async {
    QuerySnapshot querySnapshot =
        await _assignments.where('instructorId', isEqualTo: instructorId).get();

    List<Assignment> assignments = querySnapshot.docs
        .map((doc) => Assignment.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return assignments;
  }

  Future<List<Assignment>> getGroupAssignments(String groupId) async {
    QuerySnapshot querySnapshot =
        await _assignments.where('groupIds', arrayContains: groupId).get();

    List<Assignment> assignments = querySnapshot.docs
        .map((doc) => Assignment.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return assignments;
  }
}
