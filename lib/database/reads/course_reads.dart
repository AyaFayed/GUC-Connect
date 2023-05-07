import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';

class CourseReads {
  final CollectionReference<Map<String, dynamic>> _courses =
      DatabaseReferences.courses;

  Future<Course?> getCourse(String courseId) async {
    final courseData = await DatabaseReferences.getDocumentData(
        DatabaseReferences.courses, courseId);
    if (courseData != null) {
      Course course = Course.fromJson(courseData);
      return course;
    }
    return null;
  }

  Future<List<Course>> getCourseListFromIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    QuerySnapshot querySnapshot =
        await _courses.where('id', whereIn: ids).get();

    List<Course> courses = querySnapshot.docs
        .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return courses;
  }

  Future<List<Course>> getAllCourses() async {
    QuerySnapshot querySnapshot = await _courses.get();

    List<Course> allCourses = querySnapshot.docs
        .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allCourses;
  }
}
