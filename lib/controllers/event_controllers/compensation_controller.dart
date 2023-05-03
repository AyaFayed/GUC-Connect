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
      String courseName,
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
          creatorId: _auth.currentUser?.uid ?? '',
          courseId: courseId,
          title: title,
          description: description,
          file: file,
          groupIds: groupIds,
          start: start,
          end: end);

      final json = compensationLecture.toJson();

      await doccompensationLecture.set(json);

      await _helper.addEventToInstructor(
          courseId, doccompensationLecture.id, EventType.compensationLectures);

      await _helper.addEventInDivisions(
          courseName,
          doccompensationLecture.id,
          EventType.compensationLectures,
          DivisionType.groups,
          groupIds,
          courseName,
          title);
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
      String courseName,
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
          creatorId: _auth.currentUser?.uid ?? '',
          courseId: courseId,
          title: title,
          description: description,
          file: file,
          tutorialIds: tutorialIds,
          start: start,
          end: end);

      final json = compensationTutorial.toJson();

      await doccompensationTutorial.set(json);

      await _helper.addEventToInstructor(courseId, doccompensationTutorial.id,
          EventType.compensationTutorials);

      await _helper.addEventInDivisions(
          courseName,
          doccompensationTutorial.id,
          EventType.compensationTutorials,
          DivisionType.tutorials,
          tutorialIds,
          courseName,
          title);
    }
  }

  Future<List<CompensationLecture>> getGroupCompensationLectures(
      String groupId) async {
    Group? group = await Database.getGroup(groupId);

    if (group != null) {
      return await Database.getCompensationLectureListFromIds(
          group.compensationLectureIds);
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
      return await Database.getCompensationTutorialListFromIds(
          tutorial.compensationTutorialIds);
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

  static Future<List<String>> editCompensationLecture(
      String compensationLectureId,
      String title,
      String description,
      String? file,
      DateTime start,
      DateTime end) async {
    await Database.compensationLectures.doc(compensationLectureId).update(
        Compensation.toJsonUpdate(title, description, file, start, end));

    CompensationLecture? compensationLecture =
        await Database.getCompensationLecture(compensationLectureId);
    List<String> studentIds = [];

    if (compensationLecture != null) {
      studentIds = await Database.getDivisionsStudentIds(
          compensationLecture.groupIds, DivisionType.groups);
    }

    return studentIds;
  }

  static Future<List<String>> editCompensationTutorial(
      String compensationTutorialId,
      String title,
      String description,
      String? file,
      DateTime start,
      DateTime end) async {
    await Database.compensationTutorials.doc(compensationTutorialId).update(
        Compensation.toJsonUpdate(title, description, file, start, end));

    CompensationTutorial? compensationTutorial =
        await Database.getCompensationTutorial(compensationTutorialId);
    List<String> studentIds = [];

    if (compensationTutorial != null) {
      studentIds = await Database.getDivisionsStudentIds(
          compensationTutorial.tutorialIds, DivisionType.tutorials);
    }

    return studentIds;
  }

  Future deleteCompensationLecture(
      String courseName, String compensationLectureId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      CompensationLecture? compensationLecture =
          await Database.getCompensationLecture(compensationLectureId);

      if (compensationLecture != null) {
        await _helper.removeEventFromDivisions(
            compensationLectureId,
            EventType.compensationLectures,
            DivisionType.groups,
            compensationLecture.groupIds,
            courseName,
            '${compensationLecture.title} was removed');
        await _helper.removeEventFromInstructor(compensationLecture.courseId,
            compensationLectureId, EventType.compensationLectures);

        await Database.compensationLectures.doc(compensationLectureId).delete();
      }
    }
  }

  Future deleteCompensationTutorial(
      String courseName, String compensationTutorialId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.ta) {
      CompensationTutorial? compensationTutorial =
          await Database.getCompensationTutorial(compensationTutorialId);

      if (compensationTutorial != null) {
        await _helper.removeEventFromDivisions(
            compensationTutorialId,
            EventType.compensationTutorials,
            DivisionType.tutorials,
            compensationTutorial.tutorialIds,
            courseName,
            '${compensationTutorial.title} was removed');
        await _helper.removeEventFromInstructor(compensationTutorial.courseId,
            compensationTutorialId, EventType.compensationTutorials);

        await Database.compensationTutorials
            .doc(compensationTutorialId)
            .delete();
      }
    }
  }
}
