import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class CourseController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // course creation:
  Future createCourse(String name, Semester semester, int year) async {
    final docCourse = _database.collection('courses').doc();

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
  }

  Stream<List<Course>> getAllCourses() =>
      _database.collection('courses').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Course.fromJson(doc.data())).toList());

  Future<List<Course>> getMyCourses() async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      switch (getUserTypeFromString(user!['type'])) {
        case UserType.professor:
          Professor userData = Professor.fromJson(user);
          List<String> courseIds =
              userData.courses.map((course) => course.id).toList();
          final courses =
              await Future.wait(courseIds.map((String courseId) async {
            final docCourse = _database.collection('courses').doc(courseId);
            final courseSnapshot = await docCourse.get();
            return Course.fromJson(courseSnapshot.data()!);
          }));
          return courses;
        case UserType.student:
          Student userData = Student.fromJson(user);
          List<String> courseIds =
              userData.courses.map((course) => course.id).toList();
          final courses =
              await Future.wait(courseIds.map((String courseId) async {
            final docCourse = _database.collection('courses').doc(courseId);
            final courseSnapshot = await docCourse.get();
            return Course.fromJson(courseSnapshot.data()!);
          }));
          return courses;
        case UserType.ta:
          TA userData = TA.fromJson(user);
          List<String> courseIds =
              userData.courses.map((course) => course.id).toList();
          final courses =
              await Future.wait(courseIds.map((String courseId) async {
            final docCourse = _database.collection('courses').doc(courseId);
            final courseSnapshot = await docCourse.get();
            return Course.fromJson(courseSnapshot.data()!);
          }));
          return courses;
        default:
          return [];
      }
    } else {
      return [];
    }
  }
}
