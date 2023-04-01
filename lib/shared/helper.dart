import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

List<Course> searchCourses(String query, List<Course> courses) {
  final result = courses.where((course) {
    final courseName = course.name.toLowerCase();
    final input = query.toLowerCase();

    return courseName.contains(input);
  }).toList();
  return result;
}

UserType getUserTypeFromString(String type) {
  switch (type) {
    case 'student':
      return UserType.student;
    case 'ta':
      return UserType.ta;
    case 'admin':
      return UserType.admin;
    default:
      return UserType.professor;
  }
}

Day getDayFromString(String day) {
  switch (day) {
    case 'saturday':
      return Day.saturday;
    case 'sunday':
      return Day.sunday;
    case 'monday':
      return Day.monday;
    case 'tuesday':
      return Day.tuesday;
    case 'wednesday':
      return Day.wednesday;
    default:
      return Day.thursday;
  }
}

Slot getSlotFromString(String slot) {
  switch (slot) {
    case 'first':
      return Slot.first;
    case 'second':
      return Slot.second;
    case 'third':
      return Slot.third;
    case 'fourth':
      return Slot.fourth;
    default:
      return Slot.fifth;
  }
}

Semester getSemesterFromString(String semester) {
  switch (semester) {
    case 'winter':
      return Semester.winter;
    case 'spring':
      return Semester.spring;
    default:
      return Semester.summer;
  }
}
