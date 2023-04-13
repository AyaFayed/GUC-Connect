import 'package:flutter/material.dart';

class Compensations extends StatefulWidget {
  final String courseId;
  final String courseName;

  const Compensations(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<Compensations> createState() => _CompensationsState();
}

class _CompensationsState extends State<Compensations> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
