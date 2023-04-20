import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class CourseController {
  final UserController _user = UserController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // course creation:
  Future createCourse(String name, Semester semester, int year) async {
    List<Course> allCourses = await Database.getAllCourses();
    for (Course course in allCourses) {
      if (course.name == name &&
          course.semester == semester &&
          course.year == year) {
        return 'This course already exists.';
      }
    }
    final docCourse = Database.courses.doc();

    final course = Course(
      id: docCourse.id,
      name: name,
      semester: semester,
      year: year,
      professors: [],
      tas: [],
      groups: [],
      tutorials: [],
    );

    final json = course.toJson();

    await docCourse.set(json);

    return null;
  }

  Future<List<Course>> getAllCourses() async {
    List<Course> allCourses = await Database.getAllCourses();
    return allCourses;
  }

  Future<List<Course>> getEnrollCourses() async {
    List<Course> allCourses = await Database.getAllCourses();

    List<Course> myCourses = await getMyCourses();

    Iterable<String> myCourseIds = myCourses.map((course) => course.id);

    List<Course> enrollCourses = [];

    for (Course course in allCourses) {
      if (!myCourseIds.contains(course.id)) {
        enrollCourses.add(course);
      }
    }
    return enrollCourses;
  }

  Future<List<Course>> getMyCourses() async {
    UserType userType = await _user.getCurrentUserType();

    switch (userType) {
      case UserType.professor:
        Professor? professor =
            await Database.getProfessor(_auth.currentUser?.uid ?? '');
        List<String> courseIds =
            professor?.courses.map((course) => course.id).toList() ?? [];
        List<Course> courses = await Database.getCourseListFromIds(courseIds);
        return courses;
      case UserType.student:
        Student? student =
            await Database.getStudent(_auth.currentUser?.uid ?? '');
        List<String> courseIds =
            student?.courses.map((course) => course.id).toList() ?? [];
        List<Course> courses = await Database.getCourseListFromIds(courseIds);
        return courses;
      case UserType.ta:
        TA? ta = await Database.getTa(_auth.currentUser?.uid ?? '');
        List<String> courseIds =
            ta?.courses.map((course) => course.id).toList() ?? [];
        List<Course> courses = await Database.getCourseListFromIds(courseIds);
        return courses;
      default:
        return [];
    }
  }
}
