import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
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

  Future<int> canScheduleGroup(
      List<Group> groups, DateTime start, DateTime end) async {
    int conflicts = 0;
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

  Future<int> canScheduleTutorial(
      List<Tutorial> tutorials, DateTime start, DateTime end) async {
    int conflicts = 0;
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
}
