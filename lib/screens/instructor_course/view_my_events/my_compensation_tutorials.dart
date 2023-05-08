import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/my_scheduled_events.dart';

class MyCompensationTutorials extends StatefulWidget {
  final String courseId;
  final String courseName;
  const MyCompensationTutorials(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<MyCompensationTutorials> createState() =>
      _MyCompensationTutorialsState();
}

class _MyCompensationTutorialsState extends State<MyCompensationTutorials> {
  @override
  Widget build(BuildContext context) {
    return MyScheduledEvents(
      courseId: widget.courseId,
      courseName: widget.courseName,
      eventType: EventType.compensationTutorial,
    );
  }
}
