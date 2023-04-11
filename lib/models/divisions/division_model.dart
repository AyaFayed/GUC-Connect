import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class Division {
  String id;
  int number;
  List<Lecture> lectures;
  List<String> students;
  List<String> announcements;

  Division(
      {required this.id,
      required this.number,
      required this.lectures,
      required this.students,
      required this.announcements});

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'lectures': lectures.map((lecture) => lecture.toJson()).toList(),
        'students': students,
        'announcements': announcements
      };

  static Division fromJson(Map<String, dynamic> json) => Division(
        id: json['id'],
        number: json['number'],
        lectures: (json['lectures'] as List<dynamic>)
            .map((lecture) => Lecture.fromJson(lecture))
            .toList(),
        students: (json['students'] as List<dynamic>).cast<String>(),
        announcements: (json['announcements'] as List<dynamic>).cast<String>(),
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
