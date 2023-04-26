import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/screens/Course/my_courses.dart';
import 'package:guc_scheduling_app/screens/admin/admin_home.dart';
import 'package:guc_scheduling_app/screens/calendar/calendar.dart';
import 'package:guc_scheduling_app/screens/notifications/notifications.dart';
import 'package:guc_scheduling_app/screens/settings/settings.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final UserController _userController = UserController();
  UserType? _currentUserType;

  static const List<Widget> _widgetOptions = <Widget>[
    MyCourses(),
    Notifications(),
    Calendar(),
    Settings(),
  ];

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _getData() async {
    UserType currentUserType = await _userController.getCurrentUserType();
    setState(() {
      _currentUserType = currentUserType;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return _currentUserType == null
        ? const CircularProgressIndicator()
        : _currentUserType == UserType.admin
            ? const AdminHome()
            : Scaffold(
                appBar: AppBar(
                  title: Text(appName),
                  elevation: 0.0,
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
                      icon: Icon(Icons.notifications),
                      label: 'Notifications',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month),
                      label: 'Calendar',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
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
