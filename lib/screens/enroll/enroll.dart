import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/course_widgets/course_list.dart';
import 'package:guc_scheduling_app/widgets/search_bar.dart';

class Enroll extends StatefulWidget {
  final UserType userType;
  const Enroll({super.key, required this.userType});

  @override
  State<Enroll> createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  final CourseController _courseController = CourseController();

  List<Course>? _courses;
  List<Course>? _originalCourses;

  onSearch(String courseName) {
    setState(() {
      _courses = _originalCourses
          ?.where((course) =>
              course.name.toLowerCase().contains(courseName.toLowerCase()))
          .toList();
    });
  }

  Future<void> _getData() async {
    List<Course> coursesData = await _courseController.getEnrollCourses();

    setState(() {
      _courses = coursesData;
      _originalCourses = coursesData;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
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
        body: RefreshIndicator(
            onRefresh: _getData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  child: _courses == null
                      ? const CircularProgressIndicator()
                      : Column(children: [
                          SearchBar(search: onSearch),
                          const SizedBox(
                            height: 20.0,
                          ),
                          _courses!.isEmpty
                              ? const Image(
                                  image:
                                      AssetImage('assets/images/no_data.png'))
                              : CourseList(
                                  courses: _courses ?? [],
                                  userType: widget.userType,
                                  enroll: true),
                        ]),
                ),
              ),
            )));
  }
}
