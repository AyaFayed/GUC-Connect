import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/discussion/discussion.dart';
import 'package:guc_scheduling_app/screens/student_course/announcements.dart';
import 'package:guc_scheduling_app/screens/student_course/assessments/assessments.dart';
import 'package:guc_scheduling_app/screens/student_course/compensations/compensations.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assessments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Compensations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Discussion',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.bottomNavbar,
        showUnselectedLabels: true,
        unselectedItemColor: AppColors.unselected,
        selectedItemColor: AppColors.selected,
        onTap: (val) async {
          await _onItemTapped(val);
        },
      ),
    );
  }
}
