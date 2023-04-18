import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class CourseCard extends StatelessWidget {
  final String name;
  final Widget widget;

  const CourseCard({super.key, required this.name, required this.widget});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 22,
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        size: 28,
        color: AppColors.unselected,
      ),
      title: Text(
        name,
        style: TextStyle(fontSize: Sizes.medium, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      },
    );
  }
}
