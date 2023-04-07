import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/add/add_announcement.dart';
import 'package:guc_scheduling_app/screens/add/add_division/add_group.dart';
import 'package:guc_scheduling_app/screens/add/schedule_event/schedule_event.dart';

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
  String? _courseId;
  List<Widget>? _widgetOptions;
  @override
  void initState() {
    super.initState();
    _courseId = widget.courseId;
    _widgetOptions = <Widget>[
      AddAnnouncement(
        courseId: _courseId ?? '',
      ),
      const ScheduleEvent(),
      AddGroup(
        courseId: _courseId ?? '',
      ),
      const ScheduleEvent(),
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
            icon: Icon(Icons.notification_add),
            label: 'Announcement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More options',
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
