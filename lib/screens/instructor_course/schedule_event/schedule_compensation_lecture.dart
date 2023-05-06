import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_scheduled_event.dart';

class ScheduleCompensationLecture extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ScheduleCompensationLecture(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<ScheduleCompensationLecture> createState() =>
      _ScheduleCompensationLectureState();
}

class _ScheduleCompensationLectureState
    extends State<ScheduleCompensationLecture> {
  @override
  Widget build(BuildContext context) {
    return AddScheduledEvent(
        courseId: widget.courseId,
        courseName: widget.courseName,
        eventType: EventType.compensationLecture);
  }
}
