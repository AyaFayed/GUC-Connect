import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/course_list.dart';

import '../../models/course/course_model.dart';

class AdminAllCourses extends StatefulWidget {
  const AdminAllCourses({super.key});

  @override
  State<AdminAllCourses> createState() => _AdminAllCoursesState();
}

class _AdminAllCoursesState extends State<AdminAllCourses> {
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
