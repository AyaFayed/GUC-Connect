import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/course_widgets/course_list.dart';
import 'package:guc_scheduling_app/widgets/search_bar.dart';

import '../../models/course/course_model.dart';

class AllCourses extends StatefulWidget {
  const AllCourses({super.key});

  @override
  State<AllCourses> createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
  final CourseController _courseController = CourseController();
  final UserController _userController = UserController();

  List<Course>? _courses;
  List<Course>? _originalCourses;
  UserType? _userType;

  onSearch(String courseName) {
    setState(() {
      _courses = _originalCourses
          ?.where((course) =>
              course.name.toLowerCase().contains(courseName.toLowerCase()))
          .toList();
    });
  }

  Future<void> _getData() async {
    List<Course> coursesData = await _courseController.getAllCourses();
    UserType? userTypeData = await _userController.getCurrentUserType();

    setState(() {
      _courses = coursesData;
      _originalCourses = coursesData;
      _userType = userTypeData;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: _courses == null || _userType == null
                ? const CircularProgressIndicator()
                : Column(children: [
                    SearchBar(search: onSearch),
                    const SizedBox(
                      height: 15.0,
                    ),
                    _courses!.isEmpty
                        ? const Image(
                            image: AssetImage('assets/images/no_data.png'))
                        : CourseList(
                            courses: _courses ?? [],
                            userType: _userType ?? UserType.student,
                            enroll: false),
                  ])));
  }
}
