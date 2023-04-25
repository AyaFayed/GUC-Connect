import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/admin/add_admin.dart';
import 'package:guc_scheduling_app/services/authentication_service.dart';
import 'package:guc_scheduling_app/screens/Course/create_course.dart';
import 'package:guc_scheduling_app/screens/course/all_courses.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/bottom_bars/admin_bottom_bar.dart';

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
    AddAdmin(),
  ];

  Future<void> _onItemTapped(int index) async {
    if (index == 3) {
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
        title: Text(appName),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:
          AdminBottomBar(selectedIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
