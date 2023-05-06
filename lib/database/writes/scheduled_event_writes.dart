import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';

class ScheduledEventWrites {
  final CollectionReference<Map<String, dynamic>> _scheduledEvents =
      DatabaseReferences.scheduledEvents;

  Future deleteScheduledEvent(String id) async {
    await _scheduledEvents.doc(id).delete();
  }

  Future deleteAllScheduledEvents() async {
    QuerySnapshot querySnapshot = await _scheduledEvents.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  Future deleteCourseScheduledEvents(String courseId) async {
    QuerySnapshot querySnapshot =
        await _scheduledEvents.where('courseId', isEqualTo: courseId).get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  Future updateScheduledEvent(String eventId, String title, String description,
      String? file, DateTime start, DateTime end) async {
    await _scheduledEvents.doc(eventId).update(
        ScheduledEvent.toJsonUpdate(title, description, file, start, end));
  }
}
