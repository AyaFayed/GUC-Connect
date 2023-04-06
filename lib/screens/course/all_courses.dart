import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/screens/course/admin_course.dart';
import 'package:guc_scheduling_app/screens/course/course_card.dart';
import 'package:guc_scheduling_app/screens/enroll/professor_enroll.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

import '../../models/course/course_model.dart';

class AllCourses extends StatefulWidget {
  const AllCourses({super.key});

  @override
  State<AllCourses> createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
  final CourseController _courseController = CourseController();
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Course>>(
      stream: _courseController.getAllCourses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final courses = snapshot.data!;

          return courses.isEmpty
              ? const Text("No courses available")
              : FutureBuilder<UserType>(
                  future: _userController.getUserType(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userType = snapshot.data!;

                      return ListView(
                        shrinkWrap: true,
                        children: courses.map((Course course) {
                          return CourseCard(
                              name: course.name,
                              widget: userType == UserType.professor
                                  ? ProfessorEnroll(
                                      courseId: course.id,
                                      name: course.name,
                                      semester: course.semester.name,
                                      year: course.year,
                                    )
                                  : AdminCourse(
                                      name: course.name,
                                      semester: course.semester.name,
                                      year: course.year,
                                    ));
                        }).toList(),
                      );
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

        if (snapshot.hasError) {
          print(snapshot.error);
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
