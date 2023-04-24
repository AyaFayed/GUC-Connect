import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class StudentBottomBar extends StatefulWidget {
  final int selectedIndex;
  final Future<void> Function(int) onTap;
  const StudentBottomBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  State<StudentBottomBar> createState() => _StudentBottomBarState();
}

class _StudentBottomBarState extends State<StudentBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Announcements',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Assessments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Compensations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          label: 'Discussion',
        ),
      ],
      currentIndex: widget.selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.bottomNavbar,
      showUnselectedLabels: true,
      unselectedItemColor: AppColors.unselected,
      selectedItemColor: AppColors.selected,
      onTap: (val) async {
        await widget.onTap(val);
      },
    );
  }
}
