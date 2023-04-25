import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class AdminBottomBar extends StatefulWidget {
  final int selectedIndex;
  final Future<void> Function(int) onTap;
  const AdminBottomBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  State<AdminBottomBar> createState() => _AdminBottomBarState();
}

class _AdminBottomBarState extends State<AdminBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Create course',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          label: 'Add Admin',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Log out',
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
