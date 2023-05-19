import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/discussion/discussion.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_announcement/add_announcement.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_group/add_lecture_group.dart';
import 'package:guc_scheduling_app/screens/instructor_course/schedule_event/schedule_event.dart';
import 'package:guc_scheduling_app/widgets/bottom_bars/professor_bottom_bar.dart';
import 'package:guc_scheduling_app/widgets/drawers/professor_drawer.dart';

class ProfessorCourse extends StatefulWidget {
  final String courseId;
  final String courseName;
  final int? selectedIndex;

  const ProfessorCourse(
      {super.key,
      required this.courseId,
      required this.courseName,
      this.selectedIndex});

  @override
  State<ProfessorCourse> createState() => _ProfessorCourseState();
}

class _ProfessorCourseState extends State<ProfessorCourse> {
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;

  List<String> appBarLabels = [
    'Announcement',
    'Schedule',
    'Add Group',
    'Posts'
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
    _widgetOptions = <Widget>[
      AddAnnouncement(courseId: widget.courseId, courseName: widget.courseName),
      ScheduleEvent(
        courseId: widget.courseId,
        courseName: widget.courseName,
      ),
      AddLectureGroup(
        courseId: widget.courseId,
      ),
      Discussion(
        courseId: widget.courseId,
      ),
    ];
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            appBarLabels[_selectedIndex],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
        ),
        drawer: ProfessorDrawer(
          courseId: widget.courseId,
          courseName: widget.courseName,
          pop: false,
        ),
        body: _widgetOptions == null
            ? const Center(child: CircularProgressIndicator())
            : _widgetOptions?.elementAt(_selectedIndex),
        bottomNavigationBar: ProfessorBottomBar(
            selectedIndex: _selectedIndex, onTap: _onItemTapped));
  }
}
