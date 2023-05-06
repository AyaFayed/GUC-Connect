import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/view_scheduled_events.dart';

class Quizzes extends StatefulWidget {
  final String courseId;
  final String courseName;
  const Quizzes({super.key, required this.courseId, required this.courseName});

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  @override
  Widget build(BuildContext context) {
    return ViewScheduledEvents(
        courseId: widget.courseId,
        courseName: widget.courseName,
        eventType: EventType.quiz);
  }
}
