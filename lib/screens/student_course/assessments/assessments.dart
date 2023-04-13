import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/student_course/assessments/assignments.dart';
import 'package:guc_scheduling_app/screens/student_course/assessments/quizzes.dart';

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
            backgroundColor: const Color.fromARGB(255, 191, 26, 47),
            elevation: 0.0,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Quizzes'),
                Tab(text: 'Assignments'),
              ],
              indicatorColor: Colors.white,
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
