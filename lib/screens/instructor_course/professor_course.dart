import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/discussion/discussion.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_announcement/add_announcement.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_division/add_group.dart';
import 'package:guc_scheduling_app/screens/instructor_course/schedule_event/schedule_event.dart';
import 'package:guc_scheduling_app/widgets/bottom_bars/professor_bottom_bar.dart';
import 'package:guc_scheduling_app/widgets/drawers/professor_drawer.dart';

class ProfessorCourse extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ProfessorCourse(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<ProfessorCourse> createState() => _ProfessorCourseState();
}

class _ProfessorCourseState extends State<ProfessorCourse> {
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      AddAnnouncement(
        courseId: widget.courseId,
      ),
      AddGroup(
        courseId: widget.courseId,
      ),
      AddGroup(
        courseId: widget.courseId,
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
              child: ScheduleEvent(
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
        drawer: ProfessorDrawer(
          courseId: widget.courseId,
          courseName: widget.courseName,
          pop: false,
        ),
        body: SingleChildScrollView(
          child: _widgetOptions == null
              ? const CircularProgressIndicator()
              : _widgetOptions?.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: ProfessorBottomBar(
            selectedIndex: _selectedIndex, onTap: _onItemTapped));
  }
}
