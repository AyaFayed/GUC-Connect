import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class Course {
  String id;
  String name;
  Semester semester;
  int year;
  List<String> professors;
  List<String> tas;
  List<String> groups;
  List<String> tutorials;
  List<String> posts;

  Course({
    required this.id,
    required this.name,
    required this.semester,
    required this.year,
    required this.professors,
    required this.tas,
    required this.groups,
    required this.tutorials,
    required this.posts,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'semester': semester.name,
        'year': year,
        'professors': professors,
        'tas': tas,
        'groups': groups,
        'tutorials': tutorials,
        'posts': posts,
      };

  static Course fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        name: json['name'],
        semester: getSemesterFromString(json['semester']),
        year: json['year'],
        professors: (json['professors'] as List<dynamic>).cast<String>(),
        tas: (json['tas'] as List<dynamic>).cast<String>(),
        groups: (json['groups'] as List<dynamic>).cast<String>(),
        tutorials: (json['tutorials'] as List<dynamic>).cast<String>(),
        posts: (json['posts'] as List<dynamic>).cast<String>(),
      );
}
