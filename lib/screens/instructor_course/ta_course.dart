import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/discussion/discussion.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_announcement/add_announcement.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_group/add_tutorial_group.dart';
import 'package:guc_scheduling_app/screens/instructor_course/schedule_event/schedule_compensation_tutorial.dart';
import 'package:guc_scheduling_app/widgets/bottom_bars/ta_bottom_bar.dart';
import 'package:guc_scheduling_app/widgets/drawers/ta_drawer.dart';

class TACourse extends StatefulWidget {
  final String courseId;
  final String courseName;
  final int? selectedIndex;

  const TACourse(
      {super.key,
      required this.courseId,
      required this.courseName,
      this.selectedIndex});

  @override
  State<TACourse> createState() => _TACourseState();
}

class _TACourseState extends State<TACourse> {
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;

  List<String> appBarLabels = [
    'Announcement',
    'Compensation',
    'Add Tutorial',
    'Posts'
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
    _widgetOptions = <Widget>[
      AddAnnouncement(courseId: widget.courseId, courseName: widget.courseName),
      ScheduleCompensationTutorial(
          courseId: widget.courseId, courseName: widget.courseName),
      AddTutorialGroup(
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
      drawer: TADrawer(
          courseId: widget.courseId, courseName: widget.courseName, pop: false),
      body: _widgetOptions == null
          ? const Center(child: CircularProgressIndicator())
          : _widgetOptions?.elementAt(_selectedIndex),
      bottomNavigationBar:
          TABottomBar(selectedIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
