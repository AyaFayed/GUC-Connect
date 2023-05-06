import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/my_scheduled_events.dart';

class MyCompensationLectures extends StatefulWidget {
  final String courseId;
  final String courseName;
  const MyCompensationLectures(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<MyCompensationLectures> createState() => _MyCompensationLecturesState();
}

class _MyCompensationLecturesState extends State<MyCompensationLectures> {
  @override
  Widget build(BuildContext context) {
    return MyScheduledEvents(
      courseId: widget.courseId,
      courseName: widget.courseName,
      eventType: EventType.compensationLecture,
    );
  }
}
