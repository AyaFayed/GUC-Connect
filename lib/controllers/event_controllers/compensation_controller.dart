import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/division_controller.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/schedule_event_controller.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class CompensationController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DivisionController _divisionController = DivisionController();
  final EventsControllerHelper _helper = EventsControllerHelper();
  final ScheduleEventsController _scheduleEventsController =
      ScheduleEventsController();

  Future<int> scheduleCompensationLecture(
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
      print(conflicts);
      return conflicts;
    }

    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.professor) {
        final doccompensationLecture =
            _database.collection('compensationLectures').doc();

        final compensationLecture = CompensationLecture(
            id: doccompensationLecture.id,
            creator: _auth.currentUser?.uid ?? '',
            course: courseId,
            title: title,
            notes: notes,
            files: files,
            groups: groupIds,
            start: start,
            end: end);

        final json = compensationLecture.toJson();

        await doccompensationLecture.set(json);

        await _helper.addEventToInstructor(courseId, doccompensationLecture.id,
            EventType.compensationLectures);

        await _helper.addEventInDivisions(doccompensationLecture.id,
            EventType.compensationLectures, DivisionType.groups, groupIds);
      }
    }
    print(conflicts);
    return conflicts;
  }

  Future<int> scheduleCompensationTutorial(
      String courseId,
      String title,
      String notes,
      List<String> files,
      List<String> tutorialIds,
      DateTime start,
      DateTime end) async {
    List<Tutorial> tutorials =
        await _divisionController.getTutorialListFromIds(tutorialIds);
    int conflicts = await _scheduleEventsController.canScheduleTutorial(
        tutorials, start, end);
    if (conflicts > 0) {
      return conflicts;
    }

    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.ta) {
        final doccompensationTutorial =
            _database.collection('compensationTutorials').doc();

        final compensationTutorial = CompensationTutorial(
            id: doccompensationTutorial.id,
            creator: _auth.currentUser?.uid ?? '',
            course: courseId,
            title: title,
            notes: notes,
            files: files,
            tutorials: tutorialIds,
            start: start,
            end: end);

        final json = compensationTutorial.toJson();

        await doccompensationTutorial.set(json);

        await _helper.addEventToInstructor(courseId, doccompensationTutorial.id,
            EventType.compensationTutorials);

        await _helper.addEventInDivisions(
            doccompensationTutorial.id,
            EventType.compensationTutorials,
            DivisionType.tutorials,
            tutorialIds);
      }
    }
    return conflicts;
  }
}
