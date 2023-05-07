import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class ScheduledEventReads {
  final CollectionReference<Map<String, dynamic>> _scheduledEvents =
      DatabaseReferences.scheduledEvents;

  Future<ScheduledEvent?> getScheduledEvent(String scheduledEventId) async {
    try {
      final scheduledEventData = await DatabaseReferences.getDocumentData(
          DatabaseReferences.scheduledEvents, scheduledEventId);
      if (scheduledEventData != null) {
        ScheduledEvent scheduledEvent =
            ScheduledEvent.fromJson(scheduledEventData);
        return scheduledEvent;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<ScheduledEvent>> getScheduledEventListFromIds(
      List<String> eventIds) async {
    try {
      if (eventIds.isEmpty) return [];

      QuerySnapshot querySnapshot =
          await _scheduledEvents.where('id', whereIn: eventIds).get();

      List<ScheduledEvent> scheduledEvents = querySnapshot.docs
          .map((doc) =>
              ScheduledEvent.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return scheduledEvents;
    } catch (e) {
      return [];
    }
  }

  Future<List<ScheduledEvent>> getAllScheduledEvents() async {
    try {
      QuerySnapshot querySnapshot = await _scheduledEvents.get();

      List<ScheduledEvent> allScheduledEvents = querySnapshot.docs
          .map((doc) =>
              ScheduledEvent.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allScheduledEvents;
    } catch (e) {
      return [];
    }
  }

  Future<List<ScheduledEvent>> getInstructorScheduledEvents(
      String instructorId, String courseId, EventType eventType) async {
    try {
      QuerySnapshot querySnapshot = await _scheduledEvents
          .where('courseId', isEqualTo: courseId)
          .where('instructorId', isEqualTo: instructorId)
          .where('type', isEqualTo: eventType.name)
          .get();

      List<ScheduledEvent> scheduledEvents = querySnapshot.docs
          .map((doc) =>
              ScheduledEvent.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return scheduledEvents;
    } catch (e) {
      return [];
    }
  }

  Future<List<ScheduledEvent>> getAllInstructorScheduledEvents(
      String instructorId) async {
    try {
      QuerySnapshot querySnapshot = await _scheduledEvents
          .where('instructorId', isEqualTo: instructorId)
          .get();

      List<ScheduledEvent> scheduledEvents = querySnapshot.docs
          .map((doc) =>
              ScheduledEvent.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return scheduledEvents;
    } catch (e) {
      return [];
    }
  }

  Future<List<ScheduledEvent>> getGroupScheduledEvents(
      String groupId, String courseId) async {
    try {
      QuerySnapshot querySnapshot = await _scheduledEvents
          .where('courseId', isEqualTo: courseId)
          .where('groupIds', arrayContains: groupId)
          .get();

      List<ScheduledEvent> scheduledEvents = querySnapshot.docs
          .map((doc) =>
              ScheduledEvent.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return scheduledEvents;
    } catch (e) {
      return [];
    }
  }

  Future<List<ScheduledEvent>> getGroupScheduledEventsWithType(
      String groupId, EventType eventType) async {
    try {
      QuerySnapshot querySnapshot = await _scheduledEvents
          .where('type', isEqualTo: eventType.name)
          .where('groupIds', arrayContains: groupId)
          .get();

      List<ScheduledEvent> scheduledEvents = querySnapshot.docs
          .map((doc) =>
              ScheduledEvent.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return scheduledEvents;
    } catch (e) {
      return [];
    }
  }
}
