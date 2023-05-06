import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';

class AssignmentWrites {
  final CollectionReference<Map<String, dynamic>> _assignments =
      DatabaseReferences.assignments;

  Future deleteAssignment(String id) async {
    await _assignments.doc(id).delete();
  }

  Future deleteAllAssignments() async {
    QuerySnapshot querySnapshot = await _assignments.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  Future deleteCourseAssignments(String courseId) async {
    QuerySnapshot querySnapshot =
        await _assignments.where('courseId', isEqualTo: courseId).get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  Future updateAssignment(String assignmentId, String title, String description,
      String? file, DateTime deadline) async {
    await _assignments
        .doc(assignmentId)
        .update(Assignment.toJsonUpdate(title, description, file, deadline));
  }
}
