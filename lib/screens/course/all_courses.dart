import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/course_widgets/course_list.dart';

import '../../models/course/course_model.dart';

class AllCourses extends StatefulWidget {
  const AllCourses({super.key});

  @override
  State<AllCourses> createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
  final CourseController _courseController = CourseController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Course>>(
      stream: _courseController.getAllCourses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final courses = snapshot.data!;
          return courses.isEmpty
              ? const Text("No courses available")
              : CourseList(
                  courses: courses, userType: UserType.admin, enroll: false);
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return const Text('No Data');
      },
    );
  }
}
