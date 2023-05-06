import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class Group {
  String id;
  String courseId;
  String instructorId;
  int number;
  GroupType type;
  List<Lecture> lectureSlots;
  List<String> studentIds;

  Group({
    required this.id,
    required this.courseId,
    required this.instructorId,
    required this.number,
    required this.type,
    required this.lectureSlots,
    required this.studentIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'instructorId': instructorId,
        'number': number,
        'type': type.name,
        'lectureSlots':
            lectureSlots.map((lecture) => lecture.toJson()).toList(),
        'studentIds': studentIds,
      };

  static Group fromJson(Map<String, dynamic> json) => Group(
        id: json['id'],
        courseId: json['courseId'],
        instructorId: json['instructorId'],
        number: json['number'],
        type: getGroupTypeFromString(json['type']),
        lectureSlots: (json['lectureSlots'] as List<dynamic>)
            .map((lecture) => Lecture.fromJson(lecture))
            .toList(),
        studentIds: (json['studentIds'] as List<dynamic>).cast<String>(),
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
