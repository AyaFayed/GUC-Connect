import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/student_course/announcements.dart';
import 'package:guc_scheduling_app/screens/student_course/assessments/assessments.dart';
import 'package:guc_scheduling_app/screens/student_course/compensations/compensations.dart';

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
      ),
      Announcements(
        courseId: widget.courseId,
      ),
      Announcements(
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
        backgroundColor: const Color.fromARGB(255, 191, 26, 47),
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
            label: 'Announcement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assessments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Compensations',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        onTap: (val) async {
          await _onItemTapped(val);
        },
      ),
    );
  }
}
