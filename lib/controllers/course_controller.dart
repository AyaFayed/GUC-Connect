import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/database/reads/course_reads.dart';
import 'package:guc_scheduling_app/database/writes/announcement_writes.dart';
import 'package:guc_scheduling_app/database/writes/assignment_writes.dart';
import 'package:guc_scheduling_app/database/writes/course_writes.dart';
import 'package:guc_scheduling_app/database/writes/group_writes.dart';
import 'package:guc_scheduling_app/database/writes/post_writes.dart';
import 'package:guc_scheduling_app/database/writes/scheduled_event_writes.dart';
import 'package:guc_scheduling_app/database/writes/user_writes.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class CourseController {
  final UserController _user = UserController();
  final CourseReads _courseReads = CourseReads();
  final CourseWrites _courseWrites = CourseWrites();
  final UserWrites _userWrites = UserWrites();
  final AssignmentWrites _assignmentWrites = AssignmentWrites();
  final AnnouncementWrites _announcementWrites = AnnouncementWrites();
  final PostWrites _postWrites = PostWrites();
  final ScheduledEventWrites _scheduledEventWrites = ScheduledEventWrites();
  final GroupWrites _groupWrites = GroupWrites();

  // course creation:
  Future createCourse(String name) async {
    List<Course> allCourses = await _courseReads.getAllCourses();
    for (Course course in allCourses) {
      if (course.name == name) {
        return 'This course already exists.';
      }
    }
    final docCourse = DatabaseReferences.courses.doc();

    final course = Course(
      id: docCourse.id,
      name: name,
      professorIds: [],
      taIds: [],
    );

    final json = course.toJson();

    await docCourse.set(json);

    return null;
  }

  Future<List<Course>> getAllCourses() async {
    List<Course> allCourses = await _courseReads.getAllCourses();
    return allCourses;
  }

  Future<List<Course>> getEnrollCourses() async {
    UserModel? currentUser = await _user.getCurrentUser();
    if (currentUser != null) {
      List<Course> courses =
          await _courseReads.getEnrollCourseList(currentUser.courseIds);
      return courses;
    }
    return [];
  }

  Future<List<Course>> getMyCourses() async {
    UserModel? currentUser = await _user.getCurrentUser();
    if (currentUser != null) {
      List<Course> courses =
          await _courseReads.getCourseListFromIds(currentUser.courseIds);
      return courses;
    }
    return [];
  }

  Future editCourse(String courseId, String name) async {
    UserType? currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    await _courseWrites.updateCourseName(courseId, name);
  }

  Future deleteCourse(String courseId) async {
    UserType? currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    await clearCourse(courseId);
    await _courseWrites.deleteCourse(courseId);
  }

  Future clearCourse(String courseId) async {
    UserType? currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    List<Future> deleting = [
      _announcementWrites.deleteCourseAnnouncements(courseId),
      _assignmentWrites.deleteCourseAssignments(courseId),
      _scheduledEventWrites.deleteCourseScheduledEvents(courseId),
      _postWrites.deleteCoursePosts(courseId),
      _groupWrites.deleteCourseGroups(courseId),
      _userWrites.removeCourseFromAllUsers(courseId)
    ];

    await Future.wait(deleting);

    await _courseWrites.clearCourse(courseId);
  }

  Future clearCourseList(List<String> courseIds) async {
    UserType? currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    List<Future> clearing = [];
    for (String courseId in courseIds) {
      clearing.add(clearCourse(courseId));
    }

    await Future.wait(clearing);
  }

  Future clearAllCoursesData() async {
    UserType? currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    await Future.wait([
      _announcementWrites.deleteAllAnnouncements(),
      _assignmentWrites.deleteAllAssignments(),
      _scheduledEventWrites.deleteAllScheduledEvents(),
      _groupWrites.deleteAllGroups(),
      _postWrites.deleteAllPosts(),
      _courseWrites.clearAllCourses(),
      _userWrites.clearAllUserData()
    ]);
  }
}
