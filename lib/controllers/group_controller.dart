import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/database/reads/group_reads.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class GroupController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _user = UserController();
  final GroupReads _groupReads = GroupReads();

  Future createGroup(String courseId, int number, List<Lecture> lectures,
      GroupType type) async {
    List<Group> allGroups = await _groupReads.getAllGroups();

    for (Group group in allGroups) {
      if (group.courseId == courseId &&
          group.number == number &&
          group.type == type) {
        return 'This group already exists.';
      }
    }

    bool isCurrentUserInstructor = await _user.isCurrentUserInstructor();

    if (isCurrentUserInstructor) {
      final docGroup = DatabaseReferences.groups.doc();

      if (_auth.currentUser == null) return;

      final group = Group(
          id: docGroup.id,
          courseId: courseId,
          instructorId: _auth.currentUser?.uid ?? '',
          number: number,
          type: type,
          lectureSlots: lectures,
          studentIds: []);

      final json = group.toJson();

      await docGroup.set(json);

      return null;
    }
  }

  Future<List<Group>> getCourseLectureGroups(String courseId) async {
    return await _groupReads.getCourseLectureGroups(courseId);
  }

  Future<List<Group>> getCourseTutorialGroups(String courseId) async {
    return await _groupReads.getCourseTutorialGroups(courseId);
  }
}
