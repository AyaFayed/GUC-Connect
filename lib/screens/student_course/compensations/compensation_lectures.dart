import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/view_scheduled_events.dart';

class CompensationLectures extends StatefulWidget {
  final String courseId;
  final String courseName;
  const CompensationLectures(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<CompensationLectures> createState() => _CompensationLecturesState();
}

class _CompensationLecturesState extends State<CompensationLectures> {
  @override
  Widget build(BuildContext context) {
    return ViewScheduledEvents(
        courseId: widget.courseId,
        courseName: widget.courseName,
        eventType: EventType.compensationLecture);
  }
}
