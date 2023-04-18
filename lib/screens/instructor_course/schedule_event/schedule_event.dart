import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/instructor_course/schedule_event/schedule_assignment.dart';
import 'package:guc_scheduling_app/screens/instructor_course/schedule_event/schedule_compensation_lecture.dart';
import 'package:guc_scheduling_app/screens/instructor_course/schedule_event/schedule_quiz.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

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
            elevation: 0.0,
            bottom: TabBar(
              tabs: const [
                Tab(text: 'Quiz'),
                Tab(text: 'Assignment'),
                Tab(text: 'Compensation'),
              ],
              indicatorColor: AppColors.light,
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
