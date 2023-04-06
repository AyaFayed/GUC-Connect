import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/course/all_courses.dart';

class Enroll extends StatefulWidget {
  const Enroll({super.key});

  @override
  State<Enroll> createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Enroll'),
          backgroundColor: const Color.fromARGB(255, 191, 26, 47),
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: const SingleChildScrollView(
          child: AllCourses(),
        ));
  }
}
