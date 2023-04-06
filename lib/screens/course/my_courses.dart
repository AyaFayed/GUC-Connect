import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/screens/course/admin_course.dart';
import 'package:guc_scheduling_app/screens/course/all_courses.dart';
import 'package:guc_scheduling_app/screens/course/course_card.dart';
import 'package:guc_scheduling_app/screens/enroll/enroll.dart';

import '../../models/course/course_model.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final CourseController _courseController = CourseController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(children: [
              FutureBuilder<List<Course>>(
                future: _courseController.getMyCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    print(snapshot.data);
                    final courses = snapshot.data!;

                    return courses.isEmpty
                        ? const Text("You haven't enrolled in any courses yet")
                        : ListView(
                            shrinkWrap: true,
                            children: courses.map((Course course) {
                              return CourseCard(
                                  name: course.name,
                                  widget: AdminCourse(
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
                  return const Text('No Data');
                },
              ),
              const SizedBox(
                height: 40.0,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 40),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: const Color.fromARGB(255, 240, 173, 41)),
                  label: const Text(
                    'Enroll in new course',
                  ),
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Card(child: Enroll()),
                        ));
                  }),
            ])));
  }
}
