import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/view_scheduled_events.dart';

class CompensationTutorials extends StatefulWidget {
  final String courseId;
  final String courseName;
  const CompensationTutorials(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<CompensationTutorials> createState() => _CompensationTutorialsState();
}

class _CompensationTutorialsState extends State<CompensationTutorials> {
  @override
  Widget build(BuildContext context) {
    return ViewScheduledEvents(
        courseId: widget.courseId,
        courseName: widget.courseName,
        eventType: EventType.compensationTutorial);
  }
}
