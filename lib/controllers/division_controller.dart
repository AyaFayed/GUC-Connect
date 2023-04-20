import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/divisions/division_model.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class DivisionController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _user = UserController();

  Future addDivisionToCourse(
      String courseId, String divisionId, DivisionType divisionType) async {
    final docCourse = Database.courses.doc(courseId);
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
    List<Group> allGroups = await Database.getAllGroups();

    for (Group group in allGroups) {
      if (group.courseId == courseId && group.number == number) {
        return 'This group already exists.';
      }
    }

    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      final docGroup = Database.groups.doc();

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

      Professor? professor =
          await Database.getProfessor(_auth.currentUser?.uid ?? '');
      List<ProfessorCourse> courses = professor?.courses ?? [];
      for (ProfessorCourse course in courses) {
        if (course.id == courseId) {
          course.groups.add(docGroup.id);
        }
      }
      await Database.users
          .doc(_auth.currentUser?.uid)
          .update({'courses': courses.map((course) => course.toJson())});

      return null;
    }
  }

  Future createTutorial(
      String courseId, int number, List<Lecture> lectures) async {
    List<Tutorial> allTutorials = await Database.getAllTutorials();

    for (Tutorial tutorial in allTutorials) {
      if (tutorial.courseId == courseId && tutorial.number == number) {
        return 'This tutorial already exists.';
      }
    }
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.ta) {
      final docTutorial = Database.tutorials.doc();

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

      TA? ta = await Database.getTa(_auth.currentUser?.uid ?? '');
      List<TACourse> courses = ta?.courses ?? [];
      for (TACourse course in courses) {
        if (course.id == courseId) {
          course.tutorials.add(docTutorial.id);
        }
      }
      await Database.users
          .doc(_auth.currentUser?.uid)
          .update({'courses': courses.map((course) => course.toJson())});

      return null;
    }
  }

  Future<List<Group>> getCourseGroups(String courseId) async {
    Course? course = await Database.getCourse(courseId);
    if (course != null) {
      List<String> groupIds = course.groups;
      return await Database.getGroupListFromIds(groupIds);
    }
    return [];
  }

  Future<List<Group>> getOtherCourseGroups(String courseId) async {
    Course? course = await Database.getCourse(courseId);

    final userDoc = await _user.getCurrentUser();

    List<String> groupIds = [];

    if (course != null && userDoc != null) {
      List<String> myGroups = [];
      for (var course in userDoc['courses']) {
        if (course['id'] == courseId) {
          myGroups = (course['groups'] as List<dynamic>).cast<String>();
        }
      }
      List<String> allGroups = course.groups;

      for (String groupId in allGroups) {
        if (!myGroups.contains(groupId)) {
          groupIds.add(groupId);
        }
      }
      return await Database.getGroupListFromIds(groupIds);
    }
    return [];
  }

  Future<List<Group>> getMyCourseGroups(String courseId) async {
    final userDoc = await _user.getCurrentUser();

    if (userDoc != null) {
      for (var course in userDoc['courses']) {
        if (course['id'] == courseId) {
          List<String> groupIds =
              (course['groups'] as List<dynamic>).cast<String>();
          return await Database.getGroupListFromIds(groupIds);
        }
      }
      return [];
    }
    return [];
  }

  Future<List<Tutorial>> getCourseTutorials(String courseId) async {
    Course? course = await Database.getCourse(courseId);

    if (course != null) {
      List<String> tutorialIds = course.tutorials;
      return await Database.getTutorialListFromIds(tutorialIds);
    }
    return [];
  }

  Future<List<Tutorial>> getMyCourseTutorials(String courseId) async {
    final userDoc = await _user.getCurrentUser();

    if (userDoc != null) {
      for (var course in userDoc['courses']) {
        if (course['id'] == courseId) {
          List<String> tutorialIds =
              (course['tutorials'] as List<dynamic>).cast<String>();
          return await Database.getTutorialListFromIds(tutorialIds);
        }
      }
      return [];
    }
    return [];
  }

  Future<List<Tutorial>> getOtherCourseTutorials(String courseId) async {
    Course? course = await Database.getCourse(courseId);

    final userDoc = await _user.getCurrentUser();

    List<String> tutorialIds = [];

    if (course != null && userDoc != null) {
      List<String> myTutorials = [];
      for (var course in userDoc['courses']) {
        if (course['id'] == courseId) {
          myTutorials = (course['tutorials'] as List<dynamic>).cast<String>();
        }
      }
      List<String> allTutorials = course.tutorials;

      for (String tutorialId in allTutorials) {
        if (!myTutorials.contains(tutorialId)) {
          tutorialIds.add(tutorialId);
        }
      }
      return await Database.getTutorialListFromIds(tutorialIds);
    }
    return [];
  }
}
