import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/reads/group_reads.dart';
import 'package:guc_scheduling_app/database/writes/course_writes.dart';
import 'package:guc_scheduling_app/database/writes/group_writes.dart';
import 'package:guc_scheduling_app/database/writes/user_writes.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';

class EnrollmentController {
  final UserController _user = UserController();
  final GroupWrites _groupWrites = GroupWrites();
  final CourseWrites _courseWrites = CourseWrites();
  final UserWrites _userWrites = UserWrites();
  final GroupReads _groupReads = GroupReads();

  Future instructorEnroll(String courseId) async {
    UserModel? instructor = await _user.getCurrentUser();

    if (instructor != null) {
      if (instructor.courseIds.contains(courseId)) return;
      await _userWrites.addCourseToUser(instructor.id, courseId);
      await _courseWrites.addInstructorToCourse(
          instructor.id, courseId, instructor.type);
    }
  }

  Future studentEnroll(
      String courseId, String groupId, String tutorialId) async {
    UserModel? student = await _user.getCurrentUser();

    if (student != null) {
      if (student.courseIds.contains(courseId)) return;
      await _userWrites.addCourseToUser(student.id, courseId);
      await _groupWrites.addStudentToGroup(student.id, groupId);
      await _groupWrites.addStudentToGroup(student.id, tutorialId);
    }
  }

  Future studentUnenroll(String courseId) async {
    UserModel? student = await _user.getCurrentUser();

    if (student != null) {
      Group? lectureGroup =
          await _groupReads.getStudentCourseLectureGroup(courseId, student.id);
      if (lectureGroup != null) {
        await _groupWrites.removeStudentFromGroup(student.id, lectureGroup.id);
      }
      Group? tutorialGroup =
          await _groupReads.getStudentCourseTutorialGroup(courseId, student.id);
      if (tutorialGroup != null) {
        await _groupWrites.removeStudentFromGroup(student.id, tutorialGroup.id);
      }

      await _userWrites.removeCourseFromUser(student.id, courseId);
    }
  }

  Future instructorUnenroll(String courseId) async {
    UserModel? instructor = await _user.getCurrentUser();

    if (instructor != null) {
      await _courseWrites.removeInstructorFromCourse(
          instructor.id, courseId, instructor.type);
      await _userWrites.removeCourseFromUser(instructor.id, courseId);
    }
  }
}
