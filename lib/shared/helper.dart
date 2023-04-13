import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/divisions/division_model.dart';
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

String abbreviateDay(Day day) {
  switch (day) {
    case Day.saturday:
      return 'Sat';
    case Day.sunday:
      return 'Sun';
    case Day.monday:
      return 'Mon';
    case Day.tuesday:
      return 'Tues';
    case Day.wednesday:
      return 'Wed';
    case Day.thursday:
      return 'Thurs';
  }
}

String abbreviateSlot(Slot slot) {
  switch (slot) {
    case Slot.first:
      return '1st';
    case Slot.second:
      return '2nd';
    case Slot.third:
      return '3rd';
    case Slot.fourth:
      return '4th';
    case Slot.fifth:
      return '5th';
  }
}

String formatLectures(List<Lecture> lectures) {
  String result = '(';
  for (int i = 0; i < lectures.length; i++) {
    Lecture lecture = lectures[i];
    result += '${abbreviateDay(lecture.day)}-${abbreviateSlot(lecture.slot)}';
    if (i < lectures.length - 1) {
      result += ' , ';
    }
  }
  result += ')';
  return result;
}

bool isInstructor(String email) {
  try {
    String emailSecondHalf = email.split('@')[1];
    return emailSecondHalf.split('.')[0] == 'guc';
  } catch (e) {
    return false;
  }
}

bool isAdmin(String email) {
  try {
    return email == 'ayaa_fayed@yahoo.com';
  } catch (e) {
    return false;
  }
}

bool isValidMail(String email) {
  try {
    String emailSecondHalf = email.split('@')[1];
    return isAdmin(email) ||
        emailSecondHalf == 'student.guc.edu.eg' ||
        emailSecondHalf == 'guc.edu.eg';
  } catch (e) {
    return false;
  }
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

String formatDateRange(DateTime start, DateTime end) {
  return '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year.toString()} from ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} to ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
}
