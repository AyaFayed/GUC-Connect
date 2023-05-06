import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';

class GroupWrites {
  final CollectionReference<Map<String, dynamic>> _groups =
      DatabaseReferences.groups;

  Future deleteGroup(String id) async {
    await _groups.doc(id).delete();
  }

  Future deleteAllGroups() async {
    QuerySnapshot querySnapshot = await DatabaseReferences.groups.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  Future deleteCourseGroups(String courseId) async {
    QuerySnapshot querySnapshot =
        await _groups.where('courseId', isEqualTo: courseId).get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  Future addStudentToGroup(String studentId, String groupId) async {
    await _groups.doc(groupId).update({
      'studentIds': FieldValue.arrayUnion([studentId])
    });
  }

  Future removeStudentFromGroup(String studentId, String groupId) async {
    await _groups.doc(groupId).update({
      'studentIds': FieldValue.arrayRemove([studentId])
    });
  }
}
