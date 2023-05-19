import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/admin/clear_courses.dart';
import 'package:guc_scheduling_app/screens/admin/create_course.dart';
import 'package:guc_scheduling_app/screens/course/all_courses.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/bottom_bars/admin_bottom_bar.dart';
import 'package:guc_scheduling_app/widgets/drawers/admin_drawer.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AllCourses(),
    CreateCourse(),
    ClearCourses(),
  ];

  List<String> appBarLabels = [appName, 'Create Course', 'Clear Courses'];

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
      drawer: const AdminDrawer(pop: false),
      body: SingleChildScrollView(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:
          AdminBottomBar(selectedIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
