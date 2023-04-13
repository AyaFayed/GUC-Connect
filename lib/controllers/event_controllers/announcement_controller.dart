import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class AnnouncementController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventsControllerHelper _helper = EventsControllerHelper();

  Future createAnnouncement(String courseId, String title, String description,
      List<String> files, List<String> groups, List<String> tutorials) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final user = userSnapshot.data();
      if (getUserTypeFromString(user!['type']) == UserType.ta ||
          getUserTypeFromString(user['type']) == UserType.professor) {
        final docAnnouncement = _database.collection('announcements').doc();

        final announcement = Announcement(
            id: docAnnouncement.id,
            creator: _auth.currentUser?.uid ?? '',
            course: courseId,
            title: title,
            description: description,
            files: files,
            groups: groups,
            tutorials: tutorials,
            createdAt: DateTime.now());

        final json = announcement.toJson();

        await docAnnouncement.set(json);

        await _helper.addEventToInstructor(
            courseId, docAnnouncement.id, EventType.announcements);

        await _helper.addEventInDivisions(docAnnouncement.id,
            EventType.announcements, DivisionType.groups, groups);

        await _helper.addEventInDivisions(docAnnouncement.id,
            EventType.announcements, DivisionType.tutorials, tutorials);
      }
    }
  }

  Future<List<Announcement>> getGroupAnnouncements(String groupId) async {
    final docGroup = _database.collection('groups').doc(groupId);
    final groupSnapshot = await docGroup.get();

    if (groupSnapshot.exists) {
      final groupData = groupSnapshot.data();
      Group group = Group.fromJson(groupData!);

      return (await _helper.getEventsFromList(
              group.announcements, EventType.announcements) as List<dynamic>)
          .cast<Announcement>();
    } else {
      return [];
    }
  }

  Future<List<Announcement>> getTutorialAnnouncements(String tutorialId) async {
    final docTutorial = _database.collection('tutorials').doc(tutorialId);
    final tutorialSnapshot = await docTutorial.get();

    if (tutorialSnapshot.exists) {
      final tutorialData = tutorialSnapshot.data();
      Tutorial tutorial = Tutorial.fromJson(tutorialData!);

      return (await _helper.getEventsFromList(
              tutorial.announcements, EventType.announcements) as List<dynamic>)
          .cast<Announcement>();
    } else {
      return [];
    }
  }

// my group and my tutorial
  Future<List<Announcement>> getCourseAnnouncements(String courseId) async {
    final docUser = _database.collection('users').doc(_auth.currentUser?.uid);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data();
      Student student = Student.fromJson(userData!);
      for (StudentCourse course in student.courses) {
        if (courseId == course.id) {
          List<Announcement> groupAnnouncements =
              await getGroupAnnouncements(course.group);
          List<Announcement> tutorialAnnouncements =
              await getTutorialAnnouncements(course.tutorial);
          groupAnnouncements.addAll(tutorialAnnouncements);
          groupAnnouncements.sort(((Announcement a, Announcement b) =>
              b.createdAt.compareTo(a.createdAt)));
          return groupAnnouncements;
        }
      }
    }
    return [];
  }

  Future getMyAnnouncements(String courseId) async {
    return await _helper.getEventsofInstructor(
        courseId, EventType.announcements);
  }

  // Future deleteAnnouncement(String id) async {
  //   final docAnnouncement = _database.collection('announcements').doc(id);
  //   await docAnnouncement.delete();
  // }
}
