import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/course_widgets/course_list.dart';

import '../../models/course/course_model.dart';
import '../enroll/enroll.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final CourseController _courseController = CourseController();
  final UserController _userController = UserController();

  List<Course>? _courses;
  UserType? _userType;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<Course> coursesData = await _courseController.getMyCourses();
    UserType userTypeData = await _userController.getCurrentUserType();

    setState(() {
      _courses = coursesData;
      _userType = userTypeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: _userType == null
                ? const CircularProgressIndicator()
                : Column(children: [
                    _courses == null || _userType == null
                        ? const CircularProgressIndicator()
                        : _courses!.isEmpty
                            ? const Text(
                                "You haven't enrolled in any courses yet")
                            : CourseList(
                                courses: _courses ?? [],
                                userType: _userType ?? UserType.student,
                                enroll: false),
                    const SizedBox(
                      height: 40.0,
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                            textStyle: const TextStyle(fontSize: 18),
                            backgroundColor:
                                const Color.fromARGB(255, 240, 173, 41)),
                        label: const Text(
                          'Enroll in new course',
                        ),
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Card(
                                    child: Enroll(
                                        userType:
                                            _userType ?? UserType.student)),
                              ));
                        }),
                  ])));
  }
}
