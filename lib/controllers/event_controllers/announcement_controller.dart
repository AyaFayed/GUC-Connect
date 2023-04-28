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
          creator: _auth.currentUser?.uid ?? '',
          course: courseId,
          title: title,
          description: description,
          file: file,
          groups: groups,
          tutorials: tutorials,
          createdAt: DateTime.now());

      final json = announcement.toJson();

      await docAnnouncement.set(json);

      await _helper.addEventToInstructor(
          courseId, docAnnouncement.id, EventType.announcements);

      await _helper.addEventInDivisions(
          docAnnouncement.id,
          EventType.announcements,
          DivisionType.groups,
          groups,
          courseName,
          title);

      await _helper.addEventInDivisions(
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
      return await Database.getAnnouncementListFromIds(group.announcements);
    } else {
      return [];
    }
  }

  Future<List<Announcement>> getTutorialAnnouncements(String tutorialId) async {
    Tutorial? tutorial = await Database.getTutorial(tutorialId);

    if (tutorial != null) {
      return await Database.getAnnouncementListFromIds(tutorial.announcements);
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

  Future deleteAnnouncement(String announcementId) async {
    UserType userType = await _user.getCurrentUserType();

    if (userType == UserType.professor) {
      Announcement? assignment = await Database.getAnnouncement(announcementId);

      if (assignment != null) {
        await _helper.removeEventFromDivisions(announcementId,
            EventType.announcements, DivisionType.groups, assignment.groups);

        await _helper.removeEventFromDivisions(
            announcementId,
            EventType.announcements,
            DivisionType.tutorials,
            assignment.tutorials);

        await _helper.removeEventFromInstructor(
            assignment.course, announcementId, EventType.announcements);

        await Database.announcements.doc(announcementId).delete();
      }
    }
  }
}
