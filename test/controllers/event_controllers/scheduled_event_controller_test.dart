import 'package:flutter_test/flutter_test.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/scheduled_event_controller.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

void main() {
  final scheduledEventsList = [
    ScheduledEvent(
        id: '',
        instructorId: '',
        courseId: '',
        title: '',
        description: '',
        file: '',
        groupIds: [],
        start: DateTime(2023, 1, 7, 17, 0),
        end: DateTime(2023, 1, 7, 17, 30),
        type: EventType.quiz),
    ScheduledEvent(
        id: '',
        instructorId: '',
        courseId: '',
        title: '',
        description: '',
        file: '',
        groupIds: [],
        start: DateTime(2023, 1, 7, 20, 0),
        end: DateTime(2023, 1, 7, 20, 40),
        type: EventType.compensationLecture)
  ];

  test(
      'Given an event starting at 7/1/2023 16:30 and ending at 17:10 and scheduledEventsList containing an event starting at 7/1/2023 17:00 and ending at 17:30 when calling isConflicting function from ScheduledEventsController it should return true',
      () async {
    // ARRANGE
    DateTime eventStartTime = DateTime(2023, 1, 7, 16, 30);
    DateTime eventEndTime = DateTime(2023, 1, 7, 17, 10);

    // ACT
    bool isConflicting = ScheduledEventsController.isConflicting(
        scheduledEventsList, eventStartTime, eventEndTime);

    // ASSERT
    expect(isConflicting, true);
  });

  test(
      'Given an event starting at 7/1/2023 17:30 and ending at 19:20 and scheduledEventsList containing an event starting at 7/1/2023 17:00 and ending at 17:30 when calling isConflicting function from ScheduledEventsController it should return true',
      () async {
    // ARRANGE
    DateTime eventStartTime = DateTime(2023, 1, 7, 17, 30);
    DateTime eventEndTime = DateTime(2023, 1, 7, 19, 20);

    // ACT
    bool isConflicting = ScheduledEventsController.isConflicting(
        scheduledEventsList, eventStartTime, eventEndTime);

    // ASSERT
    expect(isConflicting, true);
  });

  test(
      'Given an event starting at 7/1/2023 17:05 and ending at 17:20 and scheduledEventsList containing an event starting at 7/1/2023 17:00 and ending at 17:30 when calling isConflicting function from ScheduledEventsController it should return true',
      () async {
    // ARRANGE
    DateTime eventStartTime = DateTime(2023, 1, 7, 17, 5);
    DateTime eventEndTime = DateTime(2023, 1, 7, 17, 20);

    // ACT
    bool isConflicting = ScheduledEventsController.isConflicting(
        scheduledEventsList, eventStartTime, eventEndTime);

    // ASSERT
    expect(isConflicting, true);
  });

  test(
      'Given an event starting at 7/1/2023 16:10 and ending at 19:30 and scheduledEventsList containing an event starting at 7/1/2023 17:00 and ending at 17:30 when calling isConflicting function from ScheduledEventsController it should return true',
      () async {
    // ARRANGE
    DateTime eventStartTime = DateTime(2023, 1, 7, 16, 10);
    DateTime eventEndTime = DateTime(2023, 1, 7, 19, 30);

    // ACT
    bool isConflicting = ScheduledEventsController.isConflicting(
        scheduledEventsList, eventStartTime, eventEndTime);

    // ASSERT
    expect(isConflicting, true);
  });

  test(
      'Given an event starting at 7/1/2023 18:00 and ending at 19:30 and scheduledEventsList containing an event starting at 7/1/2023 17:00 and ending at 17:30 and an event starting at 7/1/2023 20:00 and ending at 20:40 when calling isConflicting function from ScheduledEventsController it should return false',
      () async {
    // ARRANGE
    DateTime eventStartTime = DateTime(2023, 1, 7, 18, 00);
    DateTime eventEndTime = DateTime(2023, 1, 7, 19, 30);

    // ACT
    bool isConflicting = ScheduledEventsController.isConflicting(
        scheduledEventsList, eventStartTime, eventEndTime);

    // ASSERT
    expect(isConflicting, false);
  });

  test(
      'Given an event starting at 7/1/2023 19:00 and ending at 19:45 and scheduledEventsList containing an event starting at 7/1/2023 17:00 and ending at 17:30 and an event starting at 7/1/2023 20:00 and ending at 20:40 when calling isConflicting function from ScheduledEventsController it should return false',
      () async {
    // ARRANGE
    DateTime eventStartTime = DateTime(2023, 1, 7, 19, 00);
    DateTime eventEndTime = DateTime(2023, 1, 7, 19, 45);

    // ACT
    bool isConflicting = ScheduledEventsController.isConflicting(
        scheduledEventsList, eventStartTime, eventEndTime);

    // ASSERT
    expect(isConflicting, false);
  });
}
