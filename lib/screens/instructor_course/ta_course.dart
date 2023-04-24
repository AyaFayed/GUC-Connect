import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/discussion/discussion.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_announcement/add_announcement.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_division/add_tutorial.dart';
import 'package:guc_scheduling_app/screens/instructor_course/schedule_event/schedule_compensation_tutorial.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

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
        title: Text(widget.courseName),
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text(
                widget.courseName,
                style:
                    TextStyle(color: AppColors.light, fontSize: Sizes.medium),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications,
              ),
              title: const Text('My announcements'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.schedule,
              ),
              title: const Text('Scheduled compensations'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.group,
              ),
              title: const Text('My tutorials'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('Unenroll'),
              onTap: () {},
            ),
          ],
        ),
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
