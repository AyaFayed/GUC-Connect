import 'package:flutter/material.dart';

class CourseDetails extends StatelessWidget {
  final String id;
  final String name;

  const CourseDetails({
    super.key,
    required this.id,
    required this.name,
  });

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
          ],
        ),
      )),
    );
  }
}
