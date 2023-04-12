import 'package:flutter/widgets.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/screens/course/admin_course.dart';
import 'package:guc_scheduling_app/screens/course/course_card.dart';
import 'package:guc_scheduling_app/screens/course/professor_course.dart';
import 'package:guc_scheduling_app/screens/course/ta_course.dart';
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
        return AdminCourse(
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
            : AdminCourse(
                id: course.id,
                name: course.name,
                semester: course.semester,
                year: course.year);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: courses.map((Course course) {
          return CourseCard(name: course.name, widget: getWidget(course));
        }).toList());
  }
}
