import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/my_scheduled_events.dart';

class MyQuizzes extends StatefulWidget {
  final String courseId;
  final String courseName;
  const MyQuizzes(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<MyQuizzes> createState() => _MyQuizzesState();
}

class _MyQuizzesState extends State<MyQuizzes> {
  @override
  Widget build(BuildContext context) {
    return MyScheduledEvents(
      courseId: widget.courseId,
      courseName: widget.courseName,
      eventType: EventType.quiz,
    );
  }
}
