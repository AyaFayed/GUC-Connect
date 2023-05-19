import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/enrollment_controller.dart';
import 'package:guc_scheduling_app/screens/wrapper.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';

class InstructorEnroll extends StatelessWidget {
  final String courseId;
  final String courseName;

  const InstructorEnroll(
      {super.key, required this.courseName, required this.courseId});

  Future<void> enroll(BuildContext context) async {
    final EnrollmentController enrollmentController = EnrollmentController();
    await enrollmentController.instructorEnroll(courseId);
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Card(child: Wrapper()),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Enroll',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 30.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40.0),
              Text(
                courseName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Sizes.large, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40.0),
              LargeBtn(onPressed: () => enroll(context), text: 'Enroll'),
            ],
          ),
        )));
  }
}
