import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class ProfessorBottomBar extends StatefulWidget {
  final int selectedIndex;
  final Future<void> Function(int) onTap;
  const ProfessorBottomBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  State<ProfessorBottomBar> createState() => _ProfessorBottomBarState();
}

class _ProfessorBottomBarState extends State<ProfessorBottomBar> {
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
      currentIndex: widget.selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.bottomNavbar,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedItemColor: AppColors.unselected,
      selectedItemColor: AppColors.selected,
      onTap: (val) async {
        await widget.onTap(val);
      },
    );
  }
}
