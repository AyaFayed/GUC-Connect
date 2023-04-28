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

class _ScheduleEventState extends State<ScheduleEvent>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Quiz'),
            Tab(text: 'Assignment'),
            Tab(text: 'Compensation'),
          ],
          labelColor: AppColors.selected,
          indicatorColor: AppColors.selected,
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              SingleChildScrollView(
                  child: ScheduleQuiz(
                courseId: widget.courseId,
                courseName: widget.courseName,
              )),
              SingleChildScrollView(
                  child: ScheduleAssignment(
                      courseId: widget.courseId,
                      courseName: widget.courseName)),
              SingleChildScrollView(
                  child: ScheduleCompensationLecture(
                      courseId: widget.courseId,
                      courseName: widget.courseName)),
            ],
          ),
        )
      ],
    );
  }
}
