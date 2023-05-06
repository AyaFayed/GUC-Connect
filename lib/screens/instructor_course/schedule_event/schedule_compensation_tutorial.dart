import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_scheduled_event.dart';

class ScheduleCompensationTutorial extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ScheduleCompensationTutorial(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<ScheduleCompensationTutorial> createState() =>
      _ScheduleCompensationTutorialState();
}

class _ScheduleCompensationTutorialState
    extends State<ScheduleCompensationTutorial> {
  @override
  Widget build(BuildContext context) {
    return AddScheduledEvent(
        courseId: widget.courseId,
        courseName: widget.courseName,
        eventType: EventType.compensationTutorial);
  }
}
