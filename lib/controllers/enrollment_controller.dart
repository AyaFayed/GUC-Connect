import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class EnrollmentController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future addInstructorToCourse(
      String courseId, InstructorType instructorType) async {
    final docCourse = _database.collection('courses').doc(courseId);
    final courseSnapshot = await docCourse.get();

    if (courseSnapshot.exists) {
      final course = courseSnapshot.data();
      List<String> instructors =
          (course![instructorType.name] as List<dynamic>).cast<String>();
      instructors.add(_auth.currentUser?.uid ?? '');
      await docCourse.update(instructorType == InstructorType.professors
          ? {'professors': instructors}
          : {'tas': instructors});
    }
  }

  Future InstructorEnroll(String courseId) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.professor) {
        await professorEnroll(courseId, user);
      }
      if (getUserTypeFromString(user['type']) == UserType.ta) {
        await taEnroll(courseId, user);
      }
    }
  }

  Future professorEnroll(String courseId, user) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);

    Professor userData = Professor.fromJson(user);
    List<ProfessorCourse> courses = userData.courses;
    for (ProfessorCourse course in courses) {
      if (course.id == courseId) {
        return;
      }
    }
    ProfessorCourse newCourse = ProfessorCourse(
        id: courseId,
        groups: [],
        announcements: [],
        quizzes: [],
        assignments: [],
        compensationLectures: []);
    courses.add(newCourse);
    await docUser.update({'courses': courses.map((course) => course.toJson())});

    await addInstructorToCourse(courseId, InstructorType.professors);
  }

  Future taEnroll(String courseId, user) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);

    TA userData = TA.fromJson(user);
    List<TACourse> courses = userData.courses;
    for (TACourse course in courses) {
      if (course.id == courseId) {
        return;
      }
    }
    TACourse newCourse = TACourse(
        id: courseId,
        tutorials: [],
        announcements: [],
        compensationTutorials: []);
    courses.add(newCourse);
    await docUser.update({'courses': courses.map((course) => course.toJson())});

    await addInstructorToCourse(courseId, InstructorType.tas);
  }

  Future addStudentToDivision(
      String divisionId, DivisionType divisionType) async {
    final docDivision = _database.collection(divisionType.name).doc(divisionId);
    final divisionSnapshot = await docDivision.get();

    if (divisionSnapshot.exists) {
      final division = divisionSnapshot.data();
      List<String> students =
          (division!['students'] as List<dynamic>).cast<String>();
      students.add(_auth.currentUser?.uid ?? '');
      docDivision.update({'students': students});
    }
  }

  Future studentEnroll(
      String courseId, String groupId, String tutorialId) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.student) {
        Student userData = Student.fromJson(user);
        List<StudentCourse> courses = userData.courses;
        for (StudentCourse course in courses) {
          if (course.id == courseId) {
            return;
          }
        }
        StudentCourse newCourse =
            StudentCourse(id: courseId, group: groupId, tutorial: tutorialId);
        courses.add(newCourse);
        await docUser
            .update({'courses': courses.map((course) => course.toJson())});

        await addStudentToDivision(groupId, DivisionType.groups);

        await addStudentToDivision(tutorialId, DivisionType.tutorials);
      }
    }
  }
}
