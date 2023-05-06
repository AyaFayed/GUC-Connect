import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class CourseWrites {
  final CollectionReference<Map<String, dynamic>> _courses =
      DatabaseReferences.courses;

  Future deleteCourse(String id) async {
    await _courses.doc(id).delete();
  }

  Future clearCourse(String courseId) async {
    await _courses.doc(courseId).update({
      'professorIds': [],
      'taIds': [],
    });
  }

  Future clearAllCourses() async {
    QuerySnapshot querySnapshot = await _courses.get();
    await Future.wait(querySnapshot.docs
        .map((doc) => doc.reference.update({
              'professorIds': [],
              'taIds': [],
            }))
        .toList());
  }

  Future addInstructorToCourse(
      String instructorId, String courseId, UserType instructorType) async {
    await _courses.doc(courseId).update(instructorType == UserType.professor
        ? {
            'professorIds': FieldValue.arrayUnion([instructorId])
          }
        : {
            'taIds': FieldValue.arrayUnion([instructorId])
          });
  }

  Future removeInstructorFromCourse(
      String instructorId, String courseId, UserType instructorType) async {
    await _courses.doc(courseId).update(instructorType == UserType.professor
        ? {
            'professorIds': FieldValue.arrayRemove([instructorId])
          }
        : {
            'taIds': FieldValue.arrayRemove([instructorId])
          });
  }

  Future updateCourseName(String courseId, String name) async {
    await _courses.doc(courseId).update({'name': name});
  }
}
