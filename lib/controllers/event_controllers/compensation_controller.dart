import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/schedule_event_controller.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class CompensationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventsControllerHelper _helper = EventsControllerHelper();
  final UserController _user = UserController();

  final ScheduleEventsController _scheduleEventsController =
      ScheduleEventsController();

  Future<int> canScheduleCompensationLecture(
      List<String> groupIds, DateTime start, DateTime end) async {
    int conflicts = await _scheduleEventsController.canScheduleGroups(
        groupIds, start, end, null, null);
    return conflicts;
  }

  Future scheduleCompensationLecture(
      String courseId,
      String title,
      String description,
      String? file,
      List<String> groupIds,
      DateTime start,
      DateTime end) async {
    UserType userType = await _user.getCurrentUserType();
    if (userType == UserType.professor) {
      final doccompensationLecture = Database.compensationLectures.doc();

      final compensationLecture = CompensationLecture(
          id: doccompensationLecture.id,
          creator: _auth.currentUser?.uid ?? '',
          course: courseId,
          title: title,
          description: description,
          file: file,
          groups: groupIds,
          start: start,
          end: end);

      final json = compensationLecture.toJson();

      await doccompensationLecture.set(json);

      await _helper.addEventToInstructor(
          courseId, doccompensationLecture.id, EventType.compensationLectures);

      await _helper.addEventInDivisions(doccompensationLecture.id,
          EventType.compensationLectures, DivisionType.groups, groupIds);
    }
  }

  Future<int> canScheduleCompensationTutorial(
    List<String> tutorialIds,
    DateTime start,
    DateTime end,
  ) async {
    int conflicts = await _scheduleEventsController.canScheduleTutorials(
        tutorialIds, start, end, null, null);
    return conflicts;
  }

  Future scheduleCompensationTutorial(
      String courseId,
      String title,
      String description,
      String? file,
      List<String> tutorialIds,
      DateTime start,
      DateTime end) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.ta) {
      final doccompensationTutorial = Database.compensationTutorials.doc();

      final compensationTutorial = CompensationTutorial(
          id: doccompensationTutorial.id,
          creator: _auth.currentUser?.uid ?? '',
          course: courseId,
          title: title,
          description: description,
          file: file,
          tutorials: tutorialIds,
          start: start,
          end: end);

      final json = compensationTutorial.toJson();

      await doccompensationTutorial.set(json);

      await _helper.addEventToInstructor(courseId, doccompensationTutorial.id,
          EventType.compensationTutorials);

      await _helper.addEventInDivisions(doccompensationTutorial.id,
          EventType.compensationTutorials, DivisionType.tutorials, tutorialIds);
    }
  }

  Future<List<CompensationLecture>> getGroupCompensationLectures(
      String groupId) async {
    Group? group = await Database.getGroup(groupId);

    if (group != null) {
      return (await _helper.getEventsFromList(
                  group.compensationLectures, EventType.compensationLectures)
              as List<dynamic>)
          .cast<CompensationLecture>();
    } else {
      return [];
    }
  }

  Future<List<CompensationLecture>> getCompensationLectures(
      String courseId) async {
    Student? student = await Database.getStudent(_auth.currentUser?.uid ?? '');
    if (student != null) {
      for (StudentCourse course in student.courses) {
        if (course.id == courseId) {
          List<CompensationLecture> compensationLectures =
              await getGroupCompensationLectures(course.group);

          compensationLectures.sort(
              ((CompensationLecture a, CompensationLecture b) =>
                  a.start.compareTo(b.start)));
          return compensationLectures;
        }
      }
    }
    return [];
  }

  Future<List<CompensationTutorial>> getTutorialCompensationTutorials(
      String tutorialId) async {
    Tutorial? tutorial = await Database.getTutorial(tutorialId);

    if (tutorial != null) {
      return (await _helper.getEventsFromList(tutorial.compensationTutorials,
              EventType.compensationTutorials) as List<dynamic>)
          .cast<CompensationTutorial>();
    } else {
      return [];
    }
  }

  Future<List<CompensationTutorial>> getCompensationTutorials(
      String courseId) async {
    Student? student = await Database.getStudent(_auth.currentUser?.uid ?? '');
    if (student != null) {
      for (StudentCourse course in student.courses) {
        if (course.id == courseId) {
          List<CompensationTutorial> compensationTutorials =
              await getTutorialCompensationTutorials(course.tutorial);
          compensationTutorials.sort(
              ((CompensationTutorial a, CompensationTutorial b) =>
                  a.start.compareTo(b.start)));
          return compensationTutorials;
        }
      }
    }
    return [];
  }

  Future<List<CompensationLecture>> getMyCompensationLectures(
      String courseId) async {
    List<CompensationLecture> compensationLectures = (await _helper
                .getEventsofInstructor(courseId, EventType.compensationLectures)
            as List<dynamic>)
        .cast<CompensationLecture>();

    compensationLectures.sort(((CompensationLecture a, CompensationLecture b) =>
        a.start.compareTo(b.start)));
    return compensationLectures;
  }

  Future<List<CompensationTutorial>> getMyCompensationTutorials(
      String courseId) async {
    List<CompensationTutorial> compensationTutorials =
        (await _helper.getEventsofInstructor(
                courseId, EventType.compensationTutorials) as List<dynamic>)
            .cast<CompensationTutorial>();

    compensationTutorials.sort(
        ((CompensationTutorial a, CompensationTutorial b) =>
            a.start.compareTo(b.start)));
    return compensationTutorials;
  }

  static Future editCompensationLecture(
      String compensationLectureId,
      String title,
      String description,
      String? file,
      DateTime start,
      DateTime end) async {
    final docCompensationLecture =
        Database.compensationLectures.doc(compensationLectureId);

    await docCompensationLecture.update(
        Compensation.toJsonUpdate(title, description, file, start, end));
  }

  static Future editCompensationTutorial(
      String compensationTutorialId,
      String title,
      String description,
      String? file,
      DateTime start,
      DateTime end) async {
    final docCompensationTutorial =
        Database.compensationTutorials.doc(compensationTutorialId);

    await docCompensationTutorial.update(
        Compensation.toJsonUpdate(title, description, file, start, end));
  }

  Future deleteCompensationLecture(String compensationLectureId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      CompensationLecture? compensationLecture =
          await Database.getCompensationLecture(compensationLectureId);

      if (compensationLecture != null) {
        await _helper.removeEventFromDivisions(
            compensationLectureId,
            EventType.compensationLectures,
            DivisionType.groups,
            compensationLecture.groups);
        await _helper.removeEventFromInstructor(compensationLecture.course,
            compensationLectureId, EventType.compensationLectures);

        await Database.compensationLectures.doc(compensationLectureId).delete();
      }
    }
  }

  Future deleteCompensationTutorial(String compensationTutorialId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.ta) {
      CompensationTutorial? compensationTutorial =
          await Database.getCompensationTutorial(compensationTutorialId);

      if (compensationTutorial != null) {
        await _helper.removeEventFromDivisions(
            compensationTutorialId,
            EventType.compensationTutorials,
            DivisionType.tutorials,
            compensationTutorial.tutorials);
        await _helper.removeEventFromInstructor(compensationTutorial.course,
            compensationTutorialId, EventType.compensationTutorials);

        await Database.compensationTutorials
            .doc(compensationTutorialId)
            .delete();
      }
    }
  }
}
