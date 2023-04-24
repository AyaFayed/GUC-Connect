import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/discussion/discussion.dart';
import 'package:guc_scheduling_app/screens/student_course/announcements.dart';
import 'package:guc_scheduling_app/screens/student_course/assessments/assessments.dart';
import 'package:guc_scheduling_app/screens/student_course/compensations/compensations.dart';
import 'package:guc_scheduling_app/widgets/bottom_bars/student_bottom_bar.dart';

class StudentCourse extends StatefulWidget {
  final String courseId;
  final String courseName;

  const StudentCourse(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<StudentCourse> createState() => _StudentCourseState();
}

class _StudentCourseState extends State<StudentCourse> {
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Announcements(
        courseId: widget.courseId,
        courseName: widget.courseName,
      ),
      Announcements(
        courseId: widget.courseId,
        courseName: widget.courseName,
      ),
      Announcements(
        courseId: widget.courseId,
        courseName: widget.courseName,
      ),
      Discussion(
        courseId: widget.courseId,
      ),
    ];
  }

  Future<void> _onItemTapped(int index) async {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Card(
              child: Assessments(
            courseId: widget.courseId,
            courseName: widget.courseName,
          )),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Card(
              child: Compensations(
            courseId: widget.courseId,
            courseName: widget.courseName,
          )),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: _widgetOptions == null
            ? const CircularProgressIndicator()
            : _widgetOptions?.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:
          StudentBottomBar(selectedIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
