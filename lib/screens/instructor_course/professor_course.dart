import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/discussion/discussion.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_announcement/add_announcement.dart';
import 'package:guc_scheduling_app/screens/instructor_course/add_division/add_group.dart';
import 'package:guc_scheduling_app/screens/instructor_course/schedule_event/schedule_event.dart';
import 'package:guc_scheduling_app/screens/instructor_course/view_my_events/my_announcements.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Card(
                        child: MyAnnouncements(
                      courseId: widget.courseId,
                      courseName: widget.courseName,
                    )),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit_document,
              ),
              title: const Text('Scheduled quizzes'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.assignment,
              ),
              title: const Text('Posted assignments'),
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
              title: const Text('My groups'),
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
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add group',
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
