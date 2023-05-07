import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class GroupReads {
  final CollectionReference<Map<String, dynamic>> _groups =
      DatabaseReferences.groups;

  Future<Group?> getGroup(String groupId) async {
    try {
      final groupData =
          await DatabaseReferences.getDocumentData(_groups, groupId);
      if (groupData != null) {
        Group group = Group.fromJson(groupData);
        return group;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Group>> getAllGroups() async {
    try {
      QuerySnapshot querySnapshot = await _groups.get();

      List<Group> allGroups = querySnapshot.docs
          .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allGroups;
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> getGroupsStudentIds(List<String> groupIds) async {
    try {
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
    } catch (e) {
      return [];
    }
  }

  Future<Group?> getStudentCourseLectureGroup(
      String courseId, String studentId) async {
    try {
      QuerySnapshot querySnapshot = await _groups
          .where('courseId', isEqualTo: courseId)
          .where('type', isEqualTo: GroupType.lectureGroup.name)
          .where('studentIds', arrayContains: studentId)
          .get();

      List<Group> groups = querySnapshot.docs
          .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return groups.isEmpty ? null : groups.first;
    } catch (e) {
      return null;
    }
  }

  Future<Group?> getStudentCourseTutorialGroup(
      String courseId, String studentId) async {
    try {
      QuerySnapshot querySnapshot = await _groups
          .where('courseId', isEqualTo: courseId)
          .where('type', isEqualTo: GroupType.tutorialGroup.name)
          .where('studentIds', arrayContains: studentId)
          .get();

      List<Group> groups = querySnapshot.docs
          .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return groups.isEmpty ? null : groups.first;
    } catch (e) {
      return null;
    }
  }

  Future<List<Group>> getAllStudentGroups(String studentId) async {
    try {
      QuerySnapshot querySnapshot =
          await _groups.where('studentIds', arrayContains: studentId).get();

      List<Group> groups = querySnapshot.docs
          .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return groups;
    } catch (e) {
      return [];
    }
  }

  Future<List<Group>> getCourseLectureGroups(String courseId) async {
    try {
      QuerySnapshot querySnapshot = await _groups
          .where('courseId', isEqualTo: courseId)
          .where('type', isEqualTo: GroupType.lectureGroup.name)
          .get();

      List<Group> groups = querySnapshot.docs
          .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return groups;
    } catch (e) {
      return [];
    }
  }

  Future<List<Group>> getCourseTutorialGroups(String courseId) async {
    try {
      QuerySnapshot querySnapshot = await _groups
          .where('courseId', isEqualTo: courseId)
          .where('type', isEqualTo: GroupType.tutorialGroup.name)
          .get();

      List<Group> groups = querySnapshot.docs
          .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return groups;
    } catch (e) {
      return [];
    }
  }
}
