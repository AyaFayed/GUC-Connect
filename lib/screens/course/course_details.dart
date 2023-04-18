import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class CourseDetails extends StatelessWidget {
  final String id;
  final String name;
  final Semester semester;
  final int year;

  const CourseDetails(
      {super.key,
      required this.id,
      required this.name,
      required this.semester,
      required this.year});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40.0),
            Text(
              name,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            Text(
              semester.name,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            Text(
              year.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      )),
    );
  }
}
