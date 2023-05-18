import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/screens/Course/my_courses.dart';
import 'package:guc_scheduling_app/screens/admin/admin_home.dart';
import 'package:guc_scheduling_app/screens/calendar/calendar.dart';
import 'package:guc_scheduling_app/screens/notifications/notifications.dart';
import 'package:guc_scheduling_app/screens/settings/settings.dart';
import 'package:guc_scheduling_app/services/messaging_service.dart';
import 'package:guc_scheduling_app/services/notification_service.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int _notificationCount = 0;

  final UserController _userController = UserController();
  UserType? _currentUserType;

  final MessagingService _messaging = MessagingService();
  final NotificationService _notificationService = NotificationService();

  List<Widget> _widgetOptions = <Widget>[
    const MyCourses(),
    const Calendar(),
    const Settings(),
  ];

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  onNotificationClick() {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      _selectedIndex = 1;
    });
  }

  void openNotification() {
    setState(() {
      _notificationCount--;
    });
  }

  Future<void> _getData() async {
    UserType? currentUserType = await _userController.getCurrentUserType();
    int notificationCount = await _userController.getNotificationsCount();

    setState(() {
      _currentUserType = currentUserType;
      _notificationCount = notificationCount;
      _widgetOptions = <Widget>[
        const MyCourses(),
        Notifications(
          openNotification: openNotification,
        ),
        const Calendar(),
        const Settings(),
      ];
    });
  }

  @override
  void initState() {
    super.initState();

    _messaging.requestPermission();
    _messaging.setToken();
    _notificationService.initInfo(onNotificationClick);
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return _currentUserType == null
        ? Center(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                child: const CircularProgressIndicator()))
        : _currentUserType == UserType.admin
            ? const AdminHome()
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    appName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  elevation: 0.0,
                ),
                body: _widgetOptions.elementAt(_selectedIndex),
                bottomNavigationBar: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      label: 'Courses',
                    ),
                    BottomNavigationBarItem(
                      icon: _notificationCount > 0
                          ? Badge(
                              backgroundColor: AppColors.primary,
                              label: Text(_notificationCount.toString()),
                              child: const Icon(Icons.notifications),
                            )
                          : const Icon(Icons.notifications),
                      label: 'Notifications',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month),
                      label: 'Calendar',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: AppColors.bottomNavbar,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  unselectedItemColor: AppColors.unselected,
                  selectedItemColor: AppColors.selected,
                  onTap: (val) async {
                    await _onItemTapped(val);
                  },
                ),
              );
  }
}
