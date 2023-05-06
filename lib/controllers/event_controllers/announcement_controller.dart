import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/database/reads/announcement_reads.dart';
import 'package:guc_scheduling_app/database/reads/group_reads.dart';
import 'package:guc_scheduling_app/database/writes/announcement_writes.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class AnnouncementController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EventsControllerHelper _helper = EventsControllerHelper();
  final UserController _user = UserController();
  final AnnouncementReads _announcementReads = AnnouncementReads();
  final AnnouncementWrites _announcementWrites = AnnouncementWrites();
  final GroupReads _groupReads = GroupReads();

  Future createAnnouncement(
    String courseId,
    String courseName,
    String title,
    String description,
    String? file,
    List<String> groupIds,
  ) async {
    bool isCurrentUserInstructor = await _user.isCurrentUserInstructor();

    if (isCurrentUserInstructor) {
      final docAnnouncement = DatabaseReferences.announcements.doc();

      final announcement = Announcement(
          id: docAnnouncement.id,
          instructorId: _auth.currentUser?.uid ?? '',
          courseId: courseId,
          title: title,
          description: description,
          file: file,
          groupIds: groupIds,
          createdAt: DateTime.now());

      final json = announcement.toJson();

      await docAnnouncement.set(json);

      await _helper.notifyGroupsAboutEvent(courseName, docAnnouncement.id,
          EventType.announcement, groupIds, courseName, title);
    }
  }

  Future<List<Announcement>> getGroupAnnouncements(String groupId) async {
    return await _announcementReads.getGroupAnnouncements(groupId);
  }

  Future<List<Announcement>> getMyAnnouncements(String courseId) async {
    if (_auth.currentUser == null) return [];
    List<Announcement> announcements = await _announcementReads
        .getInstructorAnnouncements(_auth.currentUser?.uid ?? '', courseId);
    announcements.sort(((Announcement a, Announcement b) =>
        b.createdAt.compareTo(a.createdAt)));

    return announcements;
  }

  Future<List<Announcement>> getCourseAnnouncements(String courseId) async {
    if (_auth.currentUser == null) return [];

    Group? studentLectureGroup = await _groupReads.getStudentCourseLectureGroup(
        courseId, _auth.currentUser?.uid ?? '');
    Group? studentTutorialGroup = await _groupReads
        .getStudentCourseTutorialGroup(courseId, _auth.currentUser?.uid ?? '');

    List<Announcement> announcements = [];
    if (studentLectureGroup != null) {
      announcements.addAll(await getGroupAnnouncements(studentLectureGroup.id));
    }

    if (studentTutorialGroup != null) {
      announcements
          .addAll(await getGroupAnnouncements(studentTutorialGroup.id));
    }
    announcements.sort(((Announcement a, Announcement b) =>
        b.createdAt.compareTo(a.createdAt)));

    return announcements;
  }

  Future deleteAnnouncement(String courseName, String announcementId) async {
    bool isCurrentUserInstructor = await _user.isCurrentUserInstructor();

    if (isCurrentUserInstructor) {
      Announcement? announcement =
          await _announcementReads.getAnnouncement(announcementId);

      if (announcement != null) {
        await _helper.notifyGroupsAboutRemovedEvent(announcement.groupIds,
            courseName, '${announcement.title} was removed');

        await _announcementWrites.deleteAnnouncement(announcementId);
      }
    }
  }
}
