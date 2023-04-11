import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/schedule_event/schedule_assignment.dart';
import 'package:guc_scheduling_app/screens/schedule_event/schedule_compensation_lecture.dart';
import 'package:guc_scheduling_app/screens/schedule_event/schedule_quiz.dart';

class ScheduleEvent extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ScheduleEvent(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<ScheduleEvent> createState() => _ScheduleEventState();
}

class _ScheduleEventState extends State<ScheduleEvent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 191, 26, 47),
            elevation: 0.0,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Quiz'),
                Tab(text: 'Assignment'),
                Tab(text: 'Compensation'),
              ],
              indicatorColor: Colors.white,
            ),
            title: Text(widget.courseName),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                  child: ScheduleQuiz(courseId: widget.courseId)),
              SingleChildScrollView(
                  child: ScheduleAssignment(courseId: widget.courseId)),
              SingleChildScrollView(
                  child:
                      ScheduleCompensationLecture(courseId: widget.courseId)),
            ],
          ),
        ));
  }
}
