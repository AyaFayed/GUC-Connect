import 'package:guc_scheduling_app/controllers/event_controllers/assignment_controller.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/compensation_controller.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/quiz_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class ScheduleEventsController {
  final UserController _user = UserController();

  Future<bool> isConflictingWithQuiz(
      List<String> ids, DateTime start, DateTime end) async {
    List<Quiz> quizzes = await Database.getQuizListFromIds(ids);
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
        await Database.getCompensationLectureListFromIds(ids);
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
        await Database.getCompensationTutorialListFromIds(ids);
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
    List<String> groupIds,
    DateTime start,
    DateTime end,
    String? excludedEventId,
    EventType? excludedEventType,
  ) async {
    int conflicts = 0;
    List<Group> groups = await Database.getGroupListFromIds(groupIds);
    for (Group group in groups) {
      List<String> studentIds = group.students;
      for (String studentId in studentIds) {
        Student? student = await Database.getStudent(studentId);

        if (student != null) {
          bool isConflicting = await isConflictingForStudent(
              student, start, end, excludedEventId, excludedEventType);
          if (isConflicting) {
            conflicts++;
          }
        }
      }
    }
    return conflicts;
  }

  Future<int> canScheduleTutorials(
    List<String> tutorialIds,
    DateTime start,
    DateTime end,
    String? excludedEventId,
    EventType? excludedEventType,
  ) async {
    int conflicts = 0;
    List<Tutorial> tutorials =
        await Database.getTutorialListFromIds(tutorialIds);
    for (Tutorial tutorial in tutorials) {
      List<String> studentIds = tutorial.students;
      for (String studentId in studentIds) {
        Student? student = await Database.getStudent(studentId);

        if (student != null) {
          bool isConflicting = await isConflictingForStudent(
              student, start, end, excludedEventId, excludedEventType);
          if (isConflicting) {
            conflicts++;
          }
        }
      }
    }
    return conflicts;
  }

  Future<bool> isConflictingForStudent(
    Student student,
    DateTime start,
    DateTime end,
    String? excludedEventId,
    EventType? excludedEventType,
  ) async {
    for (StudentCourse course in student.courses) {
      Group? courseGroup = await Database.getGroup(course.group);
      if (courseGroup != null) {
        List<String> quizzes = courseGroup.quizzes;
        if (excludedEventType == EventType.quizzes) {
          quizzes.remove(excludedEventId);
        }
        bool quizConflict = await isConflictingWithQuiz(quizzes, start, end);
        List<String> compensationLectures = courseGroup.compensationLectures;
        if (excludedEventType == EventType.compensationLectures) {
          compensationLectures.remove(excludedEventId);
        }
        bool compensationLectureConflict =
            await isConflictingWithCompensationLecture(
                compensationLectures, start, end);
        if (quizConflict || compensationLectureConflict) {
          return true;
        } else {
          Tutorial? courseTutorial =
              await Database.getTutorial(course.tutorial);
          if (courseTutorial != null) {
            List<String> compensationTutorials =
                courseTutorial.compensationTutorials;
            if (excludedEventType == EventType.compensationTutorials) {
              compensationTutorials.remove(excludedEventId);
            }
            bool compensationTutorialConflict =
                await isConflictingWithCompensationTutorial(
                    compensationTutorials, start, end);
            if (compensationTutorialConflict) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  Future editScheduledEvent(
      String courseName,
      EventType eventType,
      String eventId,
      String title,
      String description,
      String? file,
      DateTime start,
      DateTime? end) async {
    UserType userType = await _user.getCurrentUserType();

    List<String> studentIds = [];

    switch (eventType) {
      case EventType.announcements:
        break;
      case EventType.assignments:
        if (userType != UserType.professor) return;
        studentIds = await AssignmentController.editAssignment(
            eventId, title, description, file, start);
        break;
      case EventType.quizzes:
        if (userType != UserType.professor) return;
        studentIds = await QuizController.editQuiz(
            eventId, title, description, file, start, end!);
        break;
      case EventType.compensationLectures:
        if (userType != UserType.professor) return;
        studentIds = await CompensationController.editCompensationLecture(
            eventId, title, description, file, start, end!);
        break;
      case EventType.compensationTutorials:
        if (userType != UserType.ta) return;
        studentIds = await CompensationController.editCompensationTutorial(
            eventId, title, description, file, start, end!);
        break;
    }

    await _user.notifyUsers(studentIds, courseName, '$title was updated.');
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
        int conflicts = await canScheduleGroups(
            quiz?.groups ?? [], start, end, eventId, eventType);
        return conflicts;
      case EventType.compensationLectures:
        CompensationLecture? compensationLecture =
            await Database.getCompensationLecture(eventId);
        int conflicts = await canScheduleGroups(
            compensationLecture?.groups ?? [], start, end, eventId, eventType);
        return conflicts;
      case EventType.compensationTutorials:
        CompensationTutorial? compensationTutorial =
            await Database.getCompensationTutorial(eventId);
        int conflicts = await canScheduleTutorials(
            compensationTutorial?.tutorials ?? [],
            start,
            end,
            eventId,
            eventType);
        return conflicts;
    }
  }
}
