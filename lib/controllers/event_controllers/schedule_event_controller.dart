import 'package:guc_scheduling_app/controllers/event_controllers/assignment_controller.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/compensation_controller.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/quiz_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class ScheduleEventsController {
  final EventsControllerHelper _helper = EventsControllerHelper();
  final AssignmentController _assignmentController = AssignmentController();
  final QuizController _quizController = QuizController();
  final CompensationController _compensationController =
      CompensationController();

  Future<bool> isConflictingWithQuiz(
      List<String> ids, DateTime start, DateTime end) async {
    List<Quiz> quizzes = (await _helper.getEventsFromList(
            ids, EventType.quizzes) as List<dynamic>)
        .cast<Quiz>();
    for (Quiz quiz in quizzes) {
      DateTime startGap = start.subtract(const Duration(minutes: 15));
      DateTime endGap = start.add(const Duration(minutes: 15));
      if (quiz.end.isAfter(startGap) && quiz.end.isBefore(endGap)) {
        return true;
      }
      if (quiz.start.isAfter(startGap) && quiz.start.isBefore(endGap)) {
        return true;
      }
    }

    return false;
  }

  Future<bool> isConflictingWithCompensationLecture(
      List<String> ids, DateTime start, DateTime end) async {
    List<CompensationLecture> compensationLectures =
        (await _helper.getEventsFromList(ids, EventType.compensationLectures)
                as List<dynamic>)
            .cast<CompensationLecture>();
    for (CompensationLecture compensationLecture in compensationLectures) {
      DateTime startGap = start.subtract(const Duration(minutes: 15));
      DateTime endGap = start.add(const Duration(minutes: 15));
      if (compensationLecture.end.isAfter(startGap) &&
          compensationLecture.end.isBefore(endGap)) {
        return true;
      }
      if (compensationLecture.start.isAfter(startGap) &&
          compensationLecture.start.isBefore(endGap)) {
        return true;
      }
    }

    return false;
  }

  Future<bool> isConflictingWithCompensationTutorial(
      List<String> ids, DateTime start, DateTime end) async {
    List<CompensationTutorial> compensationTutorials =
        (await _helper.getEventsFromList(ids, EventType.compensationTutorials)
                as List<dynamic>)
            .cast<CompensationTutorial>();
    for (CompensationTutorial compensationTutorial in compensationTutorials) {
      DateTime startGap = start.subtract(const Duration(minutes: 15));
      DateTime endGap = start.add(const Duration(minutes: 15));
      if (compensationTutorial.end.isAfter(startGap) &&
          compensationTutorial.end.isBefore(endGap)) {
        return true;
      }
      if (compensationTutorial.start.isAfter(startGap) &&
          compensationTutorial.start.isBefore(endGap)) {
        return true;
      }
    }

    return false;
  }

  Future<int> canScheduleGroups(
      List<String> groupIds, DateTime start, DateTime end) async {
    int conflicts = 0;
    List<Group> groups = await Database.getGroupListFromIds(groupIds);
    for (Group group in groups) {
      List<String> studentIds = group.students;
      for (String studentId in studentIds) {
        Student? student = await Database.getStudent(studentId);

        if (student != null) {
          bool isConflicting =
              await isConflictingForStudent(student, start, end);
          if (isConflicting) {
            conflicts++;
          }
        }
      }
    }
    return conflicts;
  }

  Future<int> canScheduleTutorials(
      List<String> tutorialIds, DateTime start, DateTime end) async {
    int conflicts = 0;
    List<Tutorial> tutorials =
        await Database.getTutorialListFromIds(tutorialIds);
    for (Tutorial tutorial in tutorials) {
      List<String> studentIds = tutorial.students;
      for (String studentId in studentIds) {
        Student? student = await Database.getStudent(studentId);

        if (student != null) {
          bool isConflicting =
              await isConflictingForStudent(student, start, end);
          if (isConflicting) {
            conflicts++;
          }
        }
      }
    }
    return conflicts;
  }

  Future<bool> isConflictingForStudent(
      Student student, DateTime start, DateTime end) async {
    for (StudentCourse course in student.courses) {
      Group? courseGroup = await Database.getGroup(course.group);
      if (courseGroup != null) {
        bool quizConflict =
            await isConflictingWithQuiz(courseGroup.quizzes, start, end);
        bool compensationLectureConflict =
            await isConflictingWithCompensationLecture(
                courseGroup.compensationLectures, start, end);
        if (quizConflict || compensationLectureConflict) {
          return true;
        } else {
          Tutorial? courseTutorial =
              await Database.getTutorial(course.tutorial);
          if (courseTutorial != null) {
            bool compensationTutorialConflict =
                await isConflictingWithCompensationTutorial(
                    courseTutorial.compensationTutorials, start, end);
            if (compensationTutorialConflict) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  Future editScheduledEvent(EventType eventType, String eventId, String title,
      String description, String? file, DateTime start, DateTime? end) async {
    switch (eventType) {
      case EventType.announcements:
        break;
      case EventType.assignments:
        await _assignmentController.editAssignment(
            eventId, title, description, file, start);
        break;
      case EventType.quizzes:
        await _quizController.editQuiz(
            eventId, title, description, file, start, end!);
        break;
      case EventType.compensationLectures:
        await _compensationController.editCompensationLecture(
            eventId, title, description, file, start, end!);
        break;
      case EventType.compensationTutorials:
        await _compensationController.editCompensationTutorial(
            eventId, title, description, file, start, end!);
        break;
    }
  }

  Future<int> canScheduleEvent(
      EventType eventType, String eventId, DateTime start, DateTime end) async {
    switch (eventType) {
      case EventType.announcements:
        return 0;
      case EventType.assignments:
        return 0;
      case EventType.quizzes:
        Quiz? quiz = await Database.getQuiz(eventId);
        int conflicts = await canScheduleGroups(quiz?.groups ?? [], start, end);
        return conflicts;
      case EventType.compensationLectures:
        CompensationLecture? compensationLecture =
            await Database.getCompensationLecture(eventId);
        int conflicts = await canScheduleGroups(
            compensationLecture?.groups ?? [], start, end);
        return conflicts;
      case EventType.compensationTutorials:
        CompensationTutorial? compensationTutorial =
            await Database.getCompensationTutorial(eventId);
        int conflicts =
            await _compensationController.canScheduleCompensationTutorial(
                compensationTutorial?.tutorials ?? [], start, end);
        return conflicts;
    }
  }
}
