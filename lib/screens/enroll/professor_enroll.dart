import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/enrollment_controller.dart';
import 'package:guc_scheduling_app/screens/home/home.dart';

class ProfessorEnroll extends StatelessWidget {
  final String courseId;
  final String name;
  final String semester;
  final int year;

  const ProfessorEnroll(
      {super.key,
      required this.name,
      required this.semester,
      required this.year,
      required this.courseId});

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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final EnrollmentController enrollmentController =
                EnrollmentController();
            await enrollmentController.professorEnroll(courseId);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Card(child: Home()),
                ));
          },
          backgroundColor: const Color.fromARGB(255, 50, 55, 59),
          label: const Text('Enroll'),
        ));
  }
}
