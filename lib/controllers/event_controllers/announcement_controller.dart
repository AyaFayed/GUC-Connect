import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class AnnouncementController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventsControllerHelper _helper = EventsControllerHelper();
  final UserController _user = UserController();

  Future createAnnouncement(
      String courseId,
      String courseName,
      String title,
      String description,
      String? file,
      List<String> groups,
      List<String> tutorials) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.ta || userType == UserType.professor) {
      final docAnnouncement = Database.announcements.doc();

      final announcement = Announcement(
          id: docAnnouncement.id,
          creatorId: _auth.currentUser?.uid ?? '',
          courseId: courseId,
          title: title,
          description: description,
          file: file,
          groupIds: groups,
          tutorialIds: tutorials,
          createdAt: DateTime.now());

      final json = announcement.toJson();

      await docAnnouncement.set(json);

      await _helper.addEventToInstructor(
          courseId, docAnnouncement.id, EventType.announcements);

      await _helper.addEventInDivisions(
          courseName,
          docAnnouncement.id,
          EventType.announcements,
          DivisionType.groups,
          groups,
          courseName,
          title);

      await _helper.addEventInDivisions(
          courseName,
          docAnnouncement.id,
          EventType.announcements,
          DivisionType.tutorials,
          tutorials,
          courseName,
          title);
    }
  }

  Future<List<Announcement>> getGroupAnnouncements(String groupId) async {
    Group? group = await Database.getGroup(groupId);

    if (group != null) {
      return await Database.getAnnouncementListFromIds(group.announcementIds);
    } else {
      return [];
    }
  }

  Future<List<Announcement>> getTutorialAnnouncements(String tutorialId) async {
    Tutorial? tutorial = await Database.getTutorial(tutorialId);

    if (tutorial != null) {
      return await Database.getAnnouncementListFromIds(
          tutorial.announcementIds);
    } else {
      return [];
    }
  }

// my group and my tutorial
  Future<List<Announcement>> getCourseAnnouncements(String courseId) async {
    Student? student = await Database.getStudent(_auth.currentUser?.uid ?? '');
    if (student != null) {
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

  Future<List<Announcement>> getMyAnnouncements(String courseId) async {
    List<Announcement> announcements = (await _helper.getEventsofInstructor(
            courseId, EventType.announcements) as List<dynamic>)
        .cast<Announcement>();
    announcements.sort(((Announcement a, Announcement b) =>
        b.createdAt.compareTo(a.createdAt)));

    return announcements;
  }

  Future deleteAnnouncement(String courseName, String announcementId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      Announcement? announcement =
          await Database.getAnnouncement(announcementId);

      if (announcement != null) {
        await _helper.removeEventFromDivisions(
            announcementId,
            EventType.announcements,
            DivisionType.groups,
            announcement.groupIds,
            courseName,
            '${announcement.title} was removed');

        await _helper.removeEventFromDivisions(
            announcementId,
            EventType.announcements,
            DivisionType.tutorials,
            announcement.tutorialIds,
            courseName,
            '${announcement.title} was removed');

        await _helper.removeEventFromInstructor(
            announcement.courseId, announcementId, EventType.announcements);

        await Database.announcements.doc(announcementId).delete();
      }
    }
  }
}
