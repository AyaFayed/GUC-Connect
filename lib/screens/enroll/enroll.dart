import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/course_list.dart';

class Enroll extends StatefulWidget {
  final UserType userType;
  const Enroll({super.key, required this.userType});

  @override
  State<Enroll> createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  final CourseController _courseController = CourseController();

  List<Course>? _courses;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<Course> coursesData = await _courseController.getEnrollCourses();

    setState(() {
      _courses = coursesData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Enroll'),
          backgroundColor: const Color.fromARGB(255, 191, 26, 47),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: _courses == null
              ? const CircularProgressIndicator()
              : CourseList(
                  courses: _courses ?? [],
                  userType: widget.userType,
                  enroll: true),
        )));
  }
}
