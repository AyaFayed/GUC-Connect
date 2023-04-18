import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/student_course/assessments/assignments.dart';
import 'package:guc_scheduling_app/screens/student_course/assessments/quizzes.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class Assessments extends StatefulWidget {
  final String courseId;
  final String courseName;

  const Assessments(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<Assessments> createState() => _AssessmentsState();
}

class _AssessmentsState extends State<Assessments> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            bottom: TabBar(
              tabs: const [
                Tab(text: 'Quizzes'),
                Tab(text: 'Assignments'),
              ],
              indicatorColor: AppColors.light,
            ),
            title: Text(widget.courseName),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                  child: Quizzes(
                courseId: widget.courseId,
                courseName: widget.courseName,
              )),
              SingleChildScrollView(
                  child: Assignments(
                courseId: widget.courseId,
                courseName: widget.courseName,
              )),
            ],
          ),
        ));
  }
}
