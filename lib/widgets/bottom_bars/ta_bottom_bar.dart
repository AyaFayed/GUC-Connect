import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class TABottomBar extends StatefulWidget {
  final int selectedIndex;
  final Future<void> Function(int) onTap;
  const TABottomBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  State<TABottomBar> createState() => _TABottomBarState();
}

class _TABottomBarState extends State<TABottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
