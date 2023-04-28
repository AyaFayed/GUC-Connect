import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/schedule_event_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class QuizController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _user = UserController();
  final EventsControllerHelper _helper = EventsControllerHelper();
  final ScheduleEventsController _scheduleEventsController =
      ScheduleEventsController();

  Future<int> canScheduleQuiz(
      List<String> groupIds, DateTime start, DateTime end) async {
    int conflicts = await _scheduleEventsController.canScheduleGroups(
        groupIds, start, end, null, null);
    return conflicts;
  }

  Future scheduleQuiz(
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
      final docQuiz = Database.quizzes.doc();

      final quiz = Quiz(
          id: docQuiz.id,
          creator: _auth.currentUser?.uid ?? '',
          course: courseId,
          title: title,
          description: description,
          file: file,
          groups: groupIds,
          start: start,
          end: end);

      final json = quiz.toJson();

      await docQuiz.set(json);

      await _helper.addEventToInstructor(
          courseId, docQuiz.id, EventType.quizzes);

      await _helper.addEventInDivisions(docQuiz.id, EventType.quizzes,
          DivisionType.groups, groupIds, courseName, title);
    }
  }

  Future<List<Quiz>> getGroupQuizzes(String groupId) async {
    Group? group = await Database.getGroup(groupId);

    if (group != null) {
      return await Database.getQuizListFromIds(group.quizzes);
    } else {
      return [];
    }
  }

  Future<List<Quiz>> getQuizzes(String courseId) async {
    Student? student = await Database.getStudent(_auth.currentUser?.uid ?? '');
    if (student != null) {
      for (StudentCourse course in student.courses) {
        if (course.id == courseId) {
          List<Quiz> quizzes = await getGroupQuizzes(course.group);
          quizzes.sort(((Quiz a, Quiz b) => a.start.compareTo(b.start)));
          return quizzes;
        }
      }
    }
    return [];
  }

  Future<List<Quiz>> getMyQuizzes(String courseId) async {
    List<Quiz> quizzes = (await _helper.getEventsofInstructor(
            courseId, EventType.quizzes) as List<dynamic>)
        .cast<Quiz>();

    quizzes.sort(((Quiz a, Quiz b) => a.start.compareTo(b.start)));
    return quizzes;
  }

  static Future editQuiz(String quizId, String title, String description,
      String? file, DateTime start, DateTime end) async {
    final docQuiz = Database.quizzes.doc(quizId);

    await docQuiz
        .update(Quiz.toJsonUpdate(title, description, file, start, end));
  }

  Future deleteQuiz(String quizId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      Quiz? quiz = await Database.getQuiz(quizId);

      if (quiz != null) {
        await _helper.removeEventFromDivisions(
            quizId, EventType.quizzes, DivisionType.groups, quiz.groups);
        await _helper.removeEventFromInstructor(
            quiz.course, quizId, EventType.quizzes);

        await Database.quizzes.doc(quizId).delete();
      }
    }
  }
}
