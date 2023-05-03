import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class Division {
  String id;
  String courseId;
  int number;
  List<Lecture> lectures;
  List<String> studentIds;
  List<String> announcementIds;

  Division(
      {required this.id,
      required this.courseId,
      required this.number,
      required this.lectures,
      required this.studentIds,
      required this.announcementIds});

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'number': number,
        'lectures': lectures.map((lecture) => lecture.toJson()).toList(),
        'studentIds': studentIds,
        'announcementIds': announcementIds
      };

  static Division fromJson(Map<String, dynamic> json) => Division(
        id: json['id'],
        courseId: json['courseId'],
        number: json['number'],
        lectures: (json['lectures'] as List<dynamic>)
            .map((lecture) => Lecture.fromJson(lecture))
            .toList(),
        studentIds: (json['studentIds'] as List<dynamic>).cast<String>(),
        announcementIds:
            (json['announcementIds'] as List<dynamic>).cast<String>(),
      );
}

class Lecture {
  Day day;
  Slot slot;

  Lecture({required this.day, required this.slot});

  Map<String, dynamic> toJson() => {
        'day': day.name,
        'slot': slot.name,
      };

  void setDay(Day day) {
    this.day = day;
  }

  void setSlot(Slot slot) {
    this.slot = slot;
  }

  static Lecture fromJson(Map<String, dynamic> json) => Lecture(
        day: getDayFromString(json['day']),
        slot: getSlotFromString(json['slot']),
      );
}
