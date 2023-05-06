import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';

class AnnouncementWrites {
  final CollectionReference<Map<String, dynamic>> _announcements =
      DatabaseReferences.announcements;

  Future deleteAnnouncement(String id) async {
    await _announcements.doc(id).delete();
  }

  Future deleteAllAnnouncements() async {
    QuerySnapshot querySnapshot = await _announcements.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  Future deleteCourseAnnouncements(String courseId) async {
    QuerySnapshot querySnapshot =
        await _announcements.where('courseId', isEqualTo: courseId).get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }
}
