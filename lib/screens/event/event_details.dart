import 'package:flutter/material.dart';

class EventDetails extends StatelessWidget {
  final String courseName;
  final String title;
  final String subtitle;
  final String description;

  const EventDetails({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
        backgroundColor: const Color.fromARGB(255, 191, 26, 47),
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
              title,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            Text(
              description,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      )),
    );
  }
}
