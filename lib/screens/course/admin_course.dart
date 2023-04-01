import 'package:flutter/material.dart';

class AdminCourse extends StatelessWidget {
  final String name;
  final String semester;
  final int year;

  const AdminCourse(
      {super.key,
      required this.name,
      required this.semester,
      required this.year});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color.fromARGB(255, 191, 26, 47),
        elevation: 0.0,
        actions: <Widget>[],
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
              semester,
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
