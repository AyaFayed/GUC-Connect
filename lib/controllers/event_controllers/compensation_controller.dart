import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/schedule_event_controller.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
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
      String courseId,
      String title,
      String description,
      List<String> files,
      List<String> groupIds,
      DateTime start,
      DateTime end) async {
    List<Group> groups = await Database.getGroupListFromIds(groupIds);

    int conflicts =
        await _scheduleEventsController.canScheduleGroup(groups, start, end);
    if (conflicts > 0) {
      return conflicts;
    }

    await scheduleCompensationLecture(
        courseId, title, description, files, groupIds, start, end);

    return 0;
  }

  Future scheduleCompensationLecture(
      String courseId,
      String title,
      String description,
      List<String> files,
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
          files: files,
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
      String courseId,
      String title,
      String description,
      List<String> files,
      List<String> tutorialIds,
      DateTime start,
      DateTime end) async {
    List<Tutorial> tutorials =
        await Database.getTutorialListFromIds(tutorialIds);
    int conflicts = await _scheduleEventsController.canScheduleTutorial(
        tutorials, start, end);
    if (conflicts > 0) {
      return conflicts;
    }

    await scheduleCompensationTutorial(
        courseId, title, description, files, tutorialIds, start, end);

    return 0;
  }

  Future scheduleCompensationTutorial(
      String courseId,
      String title,
      String description,
      List<String> files,
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
          files: files,
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
          return await getGroupCompensationLectures(course.group);
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
          return await getTutorialCompensationTutorials(course.tutorial);
        }
      }
    }
    return [];
  }
}
