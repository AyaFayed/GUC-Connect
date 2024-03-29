import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';

class AnnouncementReads {
  final CollectionReference<Map<String, dynamic>> _announcements =
      DatabaseReferences.announcements;

  Future<Announcement?> getAnnouncement(String announcementId) async {
    try {
      final announcementData = await DatabaseReferences.getDocumentData(
          DatabaseReferences.announcements, announcementId);
      if (announcementData != null) {
        Announcement announcement = Announcement.fromJson(announcementData);
        return announcement;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Announcement>> getAnnouncementListFromIds(
      List<String> eventIds) async {
    if (eventIds.isEmpty) return [];

    try {
      QuerySnapshot querySnapshot =
          await _announcements.where('id', whereIn: eventIds).get();

      List<Announcement> announcements = querySnapshot.docs
          .map((doc) =>
              Announcement.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return announcements;
    } catch (e) {
      return [];
    }
  }

  Future<List<Announcement>> getAllAnnouncements() async {
    try {
      QuerySnapshot querySnapshot = await _announcements.get();

      List<Announcement> allAnnouncements = querySnapshot.docs
          .map((doc) =>
              Announcement.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allAnnouncements;
    } catch (e) {
      return [];
    }
  }

  Future<List<Announcement>> getInstructorAnnouncements(
      String instructorId, String courseId) async {
    try {
      QuerySnapshot querySnapshot = await _announcements
          .where('courseId', isEqualTo: courseId)
          .where('instructorId', isEqualTo: instructorId)
          .get();

      List<Announcement> announcements = querySnapshot.docs
          .map((doc) =>
              Announcement.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return announcements;
    } catch (e) {
      return [];
    }
  }

  Future<List<Announcement>> getGroupAnnouncements(String groupId) async {
    try {
      QuerySnapshot querySnapshot =
          await _announcements.where('groupIds', arrayContains: groupId).get();

      List<Announcement> announcements = querySnapshot.docs
          .map((doc) =>
              Announcement.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return announcements;
    } catch (e) {
      return [];
    }
  }
}
