import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/services/storage_service.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:path/path.dart';

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

GroupType getGroupTypeFromString(String groupType) {
  if (groupType == GroupType.lectureGroup.name) {
    return GroupType.lectureGroup;
  }
  return GroupType.tutorialGroup;
}

EventType getEventTypeFromString(String eventType) {
  switch (eventType) {
    case 'announcement':
      return EventType.announcement;
    case 'assignment':
      return EventType.assignment;
    case 'quiz':
      return EventType.quiz;
    case 'compensationLecture':
      return EventType.compensationLecture;
    default:
      return EventType.compensationTutorial;
  }
}

NotificationType getNotificationTypeFromString(String notificationType) {
  switch (notificationType) {
    case 'post':
      return NotificationType.post;
    case 'reply':
      return NotificationType.reply;
    case 'announcement':
      return NotificationType.announcement;
    case 'assignment':
      return NotificationType.assignment;
    case 'quiz':
      return NotificationType.quiz;
    case 'compensationLecture':
      return NotificationType.compensationLecture;
    default:
      return NotificationType.compensationTutorial;
  }
}

NotificationType getNotificationTypeFromEventType(EventType eventType) {
  switch (eventType) {
    case EventType.announcement:
      return NotificationType.announcement;
    case EventType.assignment:
      return NotificationType.assignment;
    case EventType.quiz:
      return NotificationType.quiz;
    case EventType.compensationLecture:
      return NotificationType.compensationLecture;
    case EventType.compensationTutorial:
      return NotificationType.compensationTutorial;
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

Future<String?> uploadFile(File? file, UploadTask? task) async {
  if (file == null) return null;

  final fileName = basename(file.path);
  final destination = 'files/$fileName';

  task = StorageService.uploadFile(destination, file);

  if (task == null) return null;

  final snapshot = await task.whenComplete(() {});
  final urlDownload = await snapshot.ref.getDownloadURL();

  return urlDownload;
}

String getFileName(String path) {
  return basename(path);
}

String formatName(String name, UserType userType) {
  switch (userType) {
    case UserType.ta:
      return 'Ta. $name';
    case UserType.professor:
      return 'Dr. $name';
    case UserType.student:
    case UserType.admin:
      return name;
  }
}

String formatEventType(EventType eventType) {
  switch (eventType) {
    case EventType.announcement:
      return 'announcement';
    case EventType.assignment:
      return 'assignment';
    case EventType.quiz:
      return 'quiz';
    case EventType.compensationLecture:
      return 'compensation lecture';
    case EventType.compensationTutorial:
      return 'compensation tutorial';
  }
}

String formatEventTypePlural(EventType eventType) {
  switch (eventType) {
    case EventType.announcement:
      return 'announcements';
    case EventType.assignment:
      return 'assignments';
    case EventType.quiz:
      return 'quizzes';
    case EventType.compensationLecture:
      return 'compensation lectures';
    case EventType.compensationTutorial:
      return 'compensation tutorials';
  }
}
