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

  Future<int> scheduleQuiz(
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

    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      final docQuiz = Database.quizzes.doc();

      final quiz = Quiz(
          id: docQuiz.id,
          creator: _auth.currentUser?.uid ?? '',
          course: courseId,
          title: title,
          description: description,
          files: files,
          groups: groupIds,
          start: start,
          end: end);

      final json = quiz.toJson();

      await docQuiz.set(json);

      await _helper.addEventToInstructor(
          courseId, docQuiz.id, EventType.quizzes);

      await _helper.addEventInDivisions(
          docQuiz.id, EventType.quizzes, DivisionType.groups, groupIds);
    }
    return conflicts;
  }

  Future<List<Quiz>> getGroupQuizzes(String groupId) async {
    Group? group = await Database.getGroup(groupId);

    if (group != null) {
      return (await _helper.getEventsFromList(group.quizzes, EventType.quizzes)
              as List<dynamic>)
          .cast<Quiz>();
    } else {
      return [];
    }
  }

  Future<List<Quiz>> getQuizzes(String courseId) async {
    Student? student = await Database.getStudent(_auth.currentUser?.uid ?? '');
    if (student != null) {
      for (StudentCourse course in student.courses) {
        if (course.id == courseId) {
          return await getGroupQuizzes(course.group);
        }
      }
    }
    return [];
  }
}
