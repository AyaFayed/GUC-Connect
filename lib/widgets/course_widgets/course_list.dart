import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/screens/course/course_details.dart';
import 'package:guc_scheduling_app/screens/student_course/student_course.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/course_widgets/course_card.dart';
import 'package:guc_scheduling_app/screens/instructor_course/professor_course.dart';
import 'package:guc_scheduling_app/screens/instructor_course/ta_course.dart';
import 'package:guc_scheduling_app/screens/enroll/instructor_enroll.dart';
import 'package:guc_scheduling_app/screens/enroll/student_enroll.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class CourseList extends StatelessWidget {
  final List<Course> courses;
  final UserType userType;
  final bool enroll;

  const CourseList(
      {super.key,
      required this.courses,
      required this.userType,
      required this.enroll});

  Widget getWidget(Course course) {
    switch (userType) {
      case UserType.admin:
        return CourseDetails(
            id: course.id,
            name: course.name,
            semester: course.semester,
            year: course.year);
      case UserType.professor:
        return enroll
            ? InstructorEnroll(
                courseName: course.name,
                semester: course.semester,
                year: course.year,
                courseId: course.id)
            : ProfessorCourse(
                courseId: course.id,
                courseName: course.name,
              );
      case UserType.ta:
        return enroll
            ? InstructorEnroll(
                courseName: course.name,
                semester: course.semester,
                year: course.year,
                courseId: course.id)
            : TACourse(
                courseId: course.id,
                courseName: course.name,
              );
      case UserType.student:
        return enroll
            ? StudentEnroll(
                courseId: course.id,
                courseName: course.name,
                semester: course.semester,
                year: course.year,
              )
            : StudentCourse(courseId: course.id, courseName: course.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: courses
            .map((course) => Column(children: [
                  CourseCard(name: course.name, widget: getWidget(course)),
                  Divider(
                    color: AppColors.unselected,
                  )
                ]))
            .toList());
  }
}
