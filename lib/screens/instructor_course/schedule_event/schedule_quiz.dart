import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_scheduled_event.dart';

class ScheduleQuiz extends StatefulWidget {
  final String courseId;
  final String courseName;
  const ScheduleQuiz(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<ScheduleQuiz> createState() => _ScheduleQuizState();
}

class _ScheduleQuizState extends State<ScheduleQuiz> {
  @override
  Widget build(BuildContext context) {
    return AddScheduledEvent(
        courseId: widget.courseId,
        courseName: widget.courseName,
        eventType: EventType.quiz);
  }
}
