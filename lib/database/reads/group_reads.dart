import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class GroupReads {
  final CollectionReference<Map<String, dynamic>> _groups =
      DatabaseReferences.groups;

  Future<Group?> getGroup(String groupId) async {
    final groupData =
        await DatabaseReferences.getDocumentData(_groups, groupId);
    if (groupData != null) {
      Group group = Group.fromJson(groupData);
      return group;
    }
    return null;
  }

  Future<List<Group>> getAllGroups() async {
    QuerySnapshot querySnapshot = await _groups.get();

    List<Group> allGroups = querySnapshot.docs
        .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allGroups;
  }

  Future<List<String>> getGroupsStudentIds(List<String> groupIds) async {
    List<Future<Group?>> groupFutures = [];

    for (String groupId in groupIds) {
      groupFutures.add(getGroup(groupId));
    }

    List<Group?> groups = await Future.wait(groupFutures);

    List<String> studentIds = [];

    for (Group? group in groups) {
      if (group != null) {
        studentIds.addAll(group.studentIds);
      }
    }

    return studentIds;
  }

  Future<Group?> getStudentCourseLectureGroup(
      String courseId, String studentId) async {
    QuerySnapshot querySnapshot = await _groups
        .where('courseId', isEqualTo: courseId)
        .where('type', isEqualTo: GroupType.lectureGroup)
        .where('studentIds', arrayContains: studentId)
        .get();

    List<Group> groups = querySnapshot.docs
        .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return groups.isEmpty ? null : groups.first;
  }

  Future<Group?> getStudentCourseTutorialGroup(
      String courseId, String studentId) async {
    QuerySnapshot querySnapshot = await _groups
        .where('courseId', isEqualTo: courseId)
        .where('type', isEqualTo: GroupType.tutorialGroup)
        .where('studentIds', arrayContains: studentId)
        .get();

    List<Group> groups = querySnapshot.docs
        .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return groups.isEmpty ? null : groups.first;
  }

  Future<List<Group>> getAllStudentGroups(String studentId) async {
    QuerySnapshot querySnapshot =
        await _groups.where('studentIds', arrayContains: studentId).get();

    List<Group> groups = querySnapshot.docs
        .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return groups;
  }

  Future<List<Group>> getCourseLectureGroups(String courseId) async {
    QuerySnapshot querySnapshot = await _groups
        .where('courseId', isEqualTo: courseId)
        .where('type', isEqualTo: GroupType.lectureGroup)
        .get();

    List<Group> groups = querySnapshot.docs
        .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return groups;
  }

  Future<List<Group>> getCourseTutorialGroups(String courseId) async {
    QuerySnapshot querySnapshot = await _groups
        .where('courseId', isEqualTo: courseId)
        .where('type', isEqualTo: GroupType.tutorialGroup)
        .get();

    List<Group> groups = querySnapshot.docs
        .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return groups;
  }
}
