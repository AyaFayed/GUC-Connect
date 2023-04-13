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
    QuerySnapshot querySnapshot = await _database.collection('groups').get();

    List<Group> allGroups = querySnapshot.docs
        .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    for (Group group in allGroups) {
      if (group.courseId == courseId && group.number == number) {
        return;
      }
    }

    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.professor) {
        final docGroup = _database.collection('groups').doc();

        final group = Group(
            id: docGroup.id,
            courseId: courseId,
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
    QuerySnapshot querySnapshot = await _database.collection('tutorials').get();

    List<Tutorial> allTutorials = querySnapshot.docs
        .map((doc) => Tutorial.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    for (Tutorial tutorial in allTutorials) {
      if (tutorial.courseId == courseId && tutorial.number == number) {
        return;
      }
    }

    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.ta) {
        final docTutorial = _database.collection('tutorials').doc();

        final tutorial = Tutorial(
            id: docTutorial.id,
            courseId: courseId,
            number: number,
            lectures: lectures,
            students: [],
            announcements: [],
            compensationTutorials: []);

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

  Future<List<Group>> getGroupListFromIds(List<String> ids) async {
    List<Group> groups = [];
    for (String id in ids) {
      final docGroup = _database.collection('groups').doc(id);
      final groupSnapshot = await docGroup.get();
      if (groupSnapshot.exists) {
        final group =
            Group.fromJson(groupSnapshot.data() as Map<String, dynamic>);
        groups.add(group);
      }
    }
    return groups;
  }

  Future<List<Tutorial>> getTutorialListFromIds(List<String> ids) async {
    List<Tutorial> tutorials = [];
    for (String id in ids) {
      final docTutorial = _database.collection('tutorials').doc(id);
      final tutorialSnapshot = await docTutorial.get();
      if (tutorialSnapshot.exists) {
        final tutorial =
            Tutorial.fromJson(tutorialSnapshot.data() as Map<String, dynamic>);
        tutorials.add(tutorial);
      }
    }
    return tutorials;
  }

  Future<List<Group>> getCourseGroups(String courseId) async {
    final docCourse = _database.collection('courses').doc(courseId);
    final courseSnapshot = await docCourse.get();

    if (courseSnapshot.exists) {
      final course = courseSnapshot.data();
      List<String> groupIds =
          (course!['groups'] as List<dynamic>).cast<String>();
      return await getGroupListFromIds(groupIds);
    }
    return [];
  }

  Future<List<Group>> getOtherCourseGroups(String courseId) async {
    final docCourse = _database.collection('courses').doc(courseId);
    final courseSnapshot = await docCourse.get();

    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    List<String> groupIds = [];

    if (courseSnapshot.exists && userSnapshot.exists) {
      final course = courseSnapshot.data();
      final user = userSnapshot.data();
      List<String> myGroups = [];
      for (var course in user!['courses']) {
        if (course['id'] == courseId) {
          myGroups = (course!['groups'] as List<dynamic>).cast<String>();
        }
      }
      List<String> allGroups =
          (course!['groups'] as List<dynamic>).cast<String>();

      for (String groupId in allGroups) {
        if (!myGroups.contains(groupId)) {
          groupIds.add(groupId);
        }
      }
      return await getGroupListFromIds(groupIds);
    }
    return [];
  }

  Future<List<Group>> getMyCourseGroups(String courseId) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      for (var course in user!['courses']) {
        if (course['id'] == courseId) {
          List<String> groupIds =
              (course!['groups'] as List<dynamic>).cast<String>();
          return await getGroupListFromIds(groupIds);
        }
      }
      return [];
    }
    return [];
  }

  Future<List<Tutorial>> getCourseTutorials(String courseId) async {
    final docCourse = _database.collection('courses').doc(courseId);
    final courseSnapshot = await docCourse.get();

    if (courseSnapshot.exists) {
      final course = courseSnapshot.data();
      List<String> tutorialIds =
          (course!['tutorials'] as List<dynamic>).cast<String>();
      return await getTutorialListFromIds(tutorialIds);
    }
    return [];
  }

  Future<List<Tutorial>> getMyCourseTutorials(String courseId) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      for (var course in user!['courses']) {
        if (course['id'] == courseId) {
          List<String> tutorialIds =
              (course!['tutorials'] as List<dynamic>).cast<String>();
          return await getTutorialListFromIds(tutorialIds);
        }
      }
      return [];
    }
    return [];
  }
}
