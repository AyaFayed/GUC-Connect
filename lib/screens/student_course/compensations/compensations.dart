import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/student_course/compensations/compensation_lectures.dart';
import 'package:guc_scheduling_app/screens/student_course/compensations/compensation_tutorials.dart';

class Compensations extends StatefulWidget {
  final String courseId;
  final String courseName;

  const Compensations(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<Compensations> createState() => _CompensationsState();
}

class _CompensationsState extends State<Compensations> {
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
                Tab(text: 'Lectures'),
                Tab(text: 'Tutorials'),
              ],
              indicatorColor: Colors.white,
            ),
            title: Text(widget.courseName),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                  child: CompensationLectures(
                courseId: widget.courseId,
                courseName: widget.courseName,
              )),
              SingleChildScrollView(
                  child: CompensationTutorials(
                courseId: widget.courseId,
                courseName: widget.courseName,
              )),
            ],
          ),
        ));
  }
}
