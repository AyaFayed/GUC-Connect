import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/models/divisions/division_model.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class DivisionController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future addDivisionToCourse(
      String courseId, String divisionId, DivisionType divisionType) async {
    final docCourse = _database.collection('courses').doc(courseId);
    final courseSnapshot = await docCourse.get();

    if (courseSnapshot.exists) {
      final course = courseSnapshot.data();
      List<String> divisions =
          (course![divisionType.name] as List<dynamic>).cast<String>();
      divisions.add(divisionId);
      await docCourse.update(divisionType == DivisionType.groups
          ? {'groups': divisions}
          : {'tutorials': divisions});
    }
  }

  Future createGroup(
      String courseId, int number, List<Lecture> lectures) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.professor) {
        final docGroup = _database.collection('groups').doc();

        final group = Group(
            id: docGroup.id,
            number: number,
            lectures: lectures,
            students: [],
            announcements: [],
            quizzes: [],
            assignments: [],
            compensationLectures: []);

        final json = group.toJson();

        await docGroup.set(json);

        await addDivisionToCourse(courseId, docGroup.id, DivisionType.groups);

        Professor userData = Professor.fromJson(user);
        List<ProfessorCourse> courses = userData.courses;
        for (ProfessorCourse course in courses) {
          if (course.id == courseId) {
            course.groups.add(docGroup.id);
          }
        }
        await docUser
            .update({'courses': courses.map((course) => course.toJson())});
      }
    }
  }

  Future createTutorial(
      String courseId, int number, List<Lecture> lectures) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.ta) {
        final docTutorial = _database.collection('tutorials').doc();

        final tutorial = Tutorial(
            id: docTutorial.id,
            number: number,
            lectures: lectures,
            students: [],
            announcements: [],
            compensationTutorial: []);

        final json = tutorial.toJson();

        await docTutorial.set(json);

        await addDivisionToCourse(
            courseId, docTutorial.id, DivisionType.tutorials);

        TA userData = TA.fromJson(user);
        List<TACourse> courses = userData.courses;
        for (TACourse course in courses) {
          if (course.id == courseId) {
            course.tutorials.add(docTutorial.id);
          }
        }
        await docUser
            .update({'courses': courses.map((course) => course.toJson())});
      }
    }
  }
}
