import 'package:flutter/material.dart';

class Assessments extends StatefulWidget {
  final String courseId;
  final String courseName;
  const Assessments(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<Assessments> createState() => _AssessmentsState();
}

class _AssessmentsState extends State<Assessments> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
