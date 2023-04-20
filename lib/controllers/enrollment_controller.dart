import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class EnrollmentController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final UserController _user = UserController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future addInstructorToCourse(
      String courseId, InstructorType instructorType) async {
    final docCourse = Database.courses.doc(courseId);
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

  Future instructorEnroll(String courseId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      Professor? professor =
          await Database.getProfessor(_auth.currentUser?.uid ?? '');
      if (professor != null) {
        await professorEnroll(courseId, professor);
      }
    }
    if (userType == UserType.ta) {
      TA? ta = await Database.getTa(_auth.currentUser?.uid ?? '');
      if (ta != null) {
        await taEnroll(courseId, ta);
      }
    }
  }

  Future professorEnroll(String courseId, Professor professor) async {
    List<ProfessorCourse> courses = professor.courses;
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
    await Database.users
        .doc(_auth.currentUser?.uid)
        .update({'courses': courses.map((course) => course.toJson())});

    await addInstructorToCourse(courseId, InstructorType.professors);
  }

  Future taEnroll(String courseId, TA ta) async {
    List<TACourse> courses = ta.courses;
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
    await Database.users
        .doc(_auth.currentUser?.uid)
        .update({'courses': courses.map((course) => course.toJson())});

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
    Student? student = await Database.getStudent(_auth.currentUser?.uid ?? '');

    if (student != null) {
      List<StudentCourse> courses = student.courses;
      for (StudentCourse course in courses) {
        if (course.id == courseId) {
          return;
        }
      }
      StudentCourse newCourse =
          StudentCourse(id: courseId, group: groupId, tutorial: tutorialId);
      courses.add(newCourse);
      await Database.users
          .doc(_auth.currentUser?.uid)
          .update({'courses': courses.map((course) => course.toJson())});

      await addStudentToDivision(groupId, DivisionType.groups);

      await addStudentToDivision(tutorialId, DivisionType.tutorials);
    }
  }
}
