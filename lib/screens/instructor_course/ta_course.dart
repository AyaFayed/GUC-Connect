import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_announcement/add_announcement.dart';
import 'package:guc_scheduling_app/screens/add_division/add_tutorial.dart';
import 'package:guc_scheduling_app/screens/instructor_course/schedule_event/schedule_compensation_tutorial.dart';

class TACourse extends StatefulWidget {
  final String courseId;
  final String courseName;

  const TACourse({super.key, required this.courseId, required this.courseName});

  @override
  State<TACourse> createState() => _TACourseState();
}

class _TACourseState extends State<TACourse> {
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      AddAnnouncement(
        courseId: widget.courseId,
      ),
      ScheduleCompensationTutorial(
        courseId: widget.courseId,
      ),
      AddTutorial(
        courseId: widget.courseId,
      ),
      AddTutorial(
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
            label: 'Compensation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add tutorial',
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
