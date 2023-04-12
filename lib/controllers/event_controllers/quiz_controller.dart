import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/division_controller.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/schedule_event_controller.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class QuizController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DivisionController _divisionController = DivisionController();
  final EventsControllerHelper _helper = EventsControllerHelper();
  final ScheduleEventsController _scheduleEventsController =
      ScheduleEventsController();

  Future<int> scheduleQuiz(
      String courseId,
      String title,
      String notes,
      List<String> files,
      List<String> groupIds,
      DateTime start,
      DateTime end) async {
    List<Group> groups =
        await _divisionController.getGroupListFromIds(groupIds);
    int conflicts =
        await _scheduleEventsController.canScheduleGroup(groups, start, end);
    if (conflicts > 0) {
      return conflicts;
    }

    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.professor) {
        final docQuiz = _database.collection('quizzes').doc();

        final quiz = Quiz(
            id: docQuiz.id,
            creator: _auth.currentUser?.uid ?? '',
            course: courseId,
            title: title,
            notes: notes,
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
    }
    return conflicts;
  }
}
