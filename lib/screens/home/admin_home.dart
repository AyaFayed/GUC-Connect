import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/auth_controller.dart';
import 'package:guc_scheduling_app/screens/Course/all_courses.dart';
import 'package:guc_scheduling_app/screens/Course/create_course.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AllCourses(),
    CreateCourse(),
  ];

  Future<void> _onItemTapped(int index) async {
    if (index == 2) {
      await _auth.logout();
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
        title: const Text('GUC Notifications'),
        backgroundColor: const Color.fromARGB(255, 191, 26, 47),
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Log out',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (val) async {
          await _onItemTapped(val);
        },
      ),
    );
  }
}
