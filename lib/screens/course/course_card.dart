import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String name;
  final Widget widget;

  const CourseCard({super.key, required this.name, required this.widget});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      },
    );
  }
}
