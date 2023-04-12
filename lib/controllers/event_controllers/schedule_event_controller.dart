import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';

class ScheduleEventsController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<bool> isConflictingWithQuiz(
      List<String> ids, DateTime start, DateTime end) async {
    for (String id in ids) {
      final docQuiz = _database.collection('quizzes').doc(id);
      final quizSnapshot = await docQuiz.get();

      if (quizSnapshot.exists) {
        final quizData = quizSnapshot.data();
        Quiz quiz = Quiz.fromJson(quizData!);
        DateTime startGap = start.subtract(const Duration(minutes: 15));
        DateTime endGap = start.add(const Duration(minutes: 15));
        if (quiz.end.isAfter(startGap) && quiz.end.isBefore(endGap)) {
          return true;
        }
        if (quiz.start.isAfter(startGap) && quiz.start.isBefore(endGap)) {
          return true;
        }
      }
    }

    return false;
  }

  Future<bool> isConflictingWithCompensationLecture(
      List<String> ids, DateTime start, DateTime end) async {
    for (String id in ids) {
      final docCompensationLecture =
          _database.collection('compensationLectures').doc(id);
      final compensationLectureSnapshot = await docCompensationLecture.get();

      if (compensationLectureSnapshot.exists) {
        final compensationLectureData = compensationLectureSnapshot.data();
        CompensationLecture compensationLecture =
            CompensationLecture.fromJson(compensationLectureData!);
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
    }

    return false;
  }

  Future<bool> isConflictingWithCompensationTutorial(
      List<String> ids, DateTime start, DateTime end) async {
    for (String id in ids) {
      final docCompensationTutorial =
          _database.collection('compensationTutorials').doc(id);
      final compensationTutorialSnapshot = await docCompensationTutorial.get();

      if (compensationTutorialSnapshot.exists) {
        final compensationTutorialData = compensationTutorialSnapshot.data();
        CompensationTutorial compensationTutorial =
            CompensationTutorial.fromJson(compensationTutorialData!);
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
    }

    return false;
  }

  Future<int> canSchedule(
      List<Group> groups, DateTime start, DateTime end) async {
    int conflicts = 0;
    for (Group group in groups) {
      List<String> studentIds = group.students;
      for (String studentId in studentIds) {
        final docUser = _database.collection('users').doc(studentId);
        final userSnapshot = await docUser.get();

        if (userSnapshot.exists) {
          final user = userSnapshot.data();
          Student student = Student.fromJson(user!);
          for (StudentCourse course in student.courses) {
            final docGroup = _database.collection('groups').doc(course.group);
            final groupSnapshot = await docGroup.get();
            if (groupSnapshot.exists) {
              final courseGroupData = groupSnapshot.data();
              Group courseGroup = Group.fromJson(courseGroupData!);
              bool quizConflict =
                  await isConflictingWithQuiz(courseGroup.quizzes, start, end);
              bool compensationLectureConflict =
                  await isConflictingWithCompensationLecture(
                      courseGroup.compensationLectures, start, end);
              if (quizConflict || compensationLectureConflict) {
                conflicts++;
              } else {
                final docTutorial =
                    _database.collection('tutorials').doc(course.tutorial);
                final tutorialSnapshot = await docTutorial.get();
                if (tutorialSnapshot.exists) {
                  final courseTutorialData = tutorialSnapshot.data();
                  Tutorial courseTutorial =
                      Tutorial.fromJson(courseTutorialData!);
                  bool compensationTutorialConflict =
                      await isConflictingWithCompensationTutorial(
                          courseTutorial.compensationTutorial, start, end);
                  if (compensationTutorialConflict) {
                    conflicts++;
                  }
                }
              }
            }
          }
        }
      }
    }
    return conflicts;
  }
}
