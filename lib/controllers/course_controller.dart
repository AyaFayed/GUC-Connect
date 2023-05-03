import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class CourseController {
  final UserController _user = UserController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // course creation:
  Future createCourse(String name) async {
    List<Course> allCourses = await Database.getAllCourses();
    for (Course course in allCourses) {
      if (course.name == name) {
        return 'This course already exists.';
      }
    }
    final docCourse = Database.courses.doc();

    final course = Course(
      id: docCourse.id,
      name: name,
      professorIds: [],
      taIds: [],
      groupIds: [],
      tutorialIds: [],
      postIds: [],
    );

    final json = course.toJson();

    await docCourse.set(json);

    return null;
  }

  Future<List<Course>> getAllCourses() async {
    List<Course> allCourses = await Database.getAllCourses();
    return allCourses;
  }

  Future<List<Course>> getEnrollCourses() async {
    List<Course> allCourses = await Database.getAllCourses();

    List<Course> myCourses = await getMyCourses();

    Iterable<String> myCourseIds = myCourses.map((course) => course.id);

    List<Course> enrollCourses = [];

    for (Course course in allCourses) {
      if (!myCourseIds.contains(course.id)) {
        enrollCourses.add(course);
      }
    }
    return enrollCourses;
  }

  Future<List<Course>> getMyCourses() async {
    UserType userType = await _user.getCurrentUserType();

    switch (userType) {
      case UserType.professor:
        Professor? professor =
            await Database.getProfessor(_auth.currentUser?.uid ?? '');
        List<String> courseIds =
            professor?.courses.map((course) => course.id).toList() ?? [];
        List<Course> courses = await Database.getCourseListFromIds(courseIds);
        return courses;
      case UserType.student:
        Student? student =
            await Database.getStudent(_auth.currentUser?.uid ?? '');
        print(student);
        List<String> courseIds =
            student?.courses.map((course) => course.id).toList() ?? [];
        List<Course> courses = await Database.getCourseListFromIds(courseIds);
        return courses;
      case UserType.ta:
        TA? ta = await Database.getTa(_auth.currentUser?.uid ?? '');
        List<String> courseIds =
            ta?.courses.map((course) => course.id).toList() ?? [];
        List<Course> courses = await Database.getCourseListFromIds(courseIds);
        return courses;
      default:
        return [];
    }
  }

  Future editCourse(String courseId, String name) async {
    UserType currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    final docCourse = Database.courses.doc(courseId);
    await docCourse.update({'name': name});
  }

  Future deleteCourse(String courseId) async {
    UserType currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    await clearCourse(courseId);
    await Database.courses.doc(courseId).delete();
  }

  Future clearCourse(String courseId) async {
    UserType currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    Course? course = await Database.getCourse(courseId);
    if (course != null) {
      List<Announcement> announcements = await Database.getAllAnnouncements();
      List<Assignment> assignments = await Database.getAllAssignments();
      List<Quiz> quizzes = await Database.getAllQuizzes();
      List<CompensationLecture> compensationLectures =
          await Database.getAllCompensationLectures();
      List<CompensationTutorial> compensationTutorials =
          await Database.getAllCompensationTutorials();
      List<Future> deleting = [];
      for (Announcement announcement in announcements) {
        if (announcement.courseId == courseId) {
          deleting.add(Database.announcements.doc(announcement.id).delete());
        }
      }
      for (Assignment assignment in assignments) {
        if (assignment.courseId == courseId) {
          deleting.add(Database.assignments.doc(assignment.id).delete());
        }
      }
      for (Quiz quiz in quizzes) {
        if (quiz.courseId == courseId) {
          deleting.add(Database.quizzes.doc(quiz.id).delete());
        }
      }
      for (CompensationLecture compensationLecture in compensationLectures) {
        if (compensationLecture.courseId == courseId) {
          deleting.add(Database.compensationLectures
              .doc(compensationLecture.id)
              .delete());
        }
      }
      for (CompensationTutorial compensationTutorial in compensationTutorials) {
        if (compensationTutorial.courseId == courseId) {
          deleting.add(Database.compensationTutorials
              .doc(compensationTutorial.id)
              .delete());
        }
      }
      List<String> groupIds = course.groupIds;
      List<Group> groups = await Database.getGroupListFromIds(groupIds);
      for (Group group in groups) {
        List<String> studentIds = group.studentIds;
        for (String studentId in studentIds) {
          Student? student = await Database.getStudent(studentId);

          if (student != null) {
            List<StudentCourse> courses = student.courses;
            courses.removeWhere((course) => course.id == courseId);

            deleting.add(Database.users
                .doc(studentId)
                .update({'courses': courses.map((course) => course.toJson())}));
          }
        }
        deleting.add(Database.groups.doc(group.id).delete());
      }

      List<String> tutorialIds = course.tutorialIds;
      for (String tutorialId in tutorialIds) {
        deleting.add(Database.tutorials.doc(tutorialId).delete());
      }

      List<String> professorIds = course.professorIds;
      for (String professorId in professorIds) {
        Professor? professor = await Database.getProfessor(professorId);

        if (professor != null) {
          List<ProfessorCourse> courses = professor.courses;

          courses.removeWhere((course) => course.id == courseId);

          deleting.add(Database.users
              .doc(professorId)
              .update({'courses': courses.map((course) => course.toJson())}));
        }
      }
      List<String> taIds = course.taIds;
      for (String taId in taIds) {
        TA? ta = await Database.getTa(taId);

        if (ta != null) {
          List<TACourse> courses = ta.courses;

          courses.removeWhere((course) => course.id == courseId);

          deleting.add(Database.users
              .doc(taId)
              .update({'courses': courses.map((course) => course.toJson())}));
        }
      }
      List<String> postIds = course.postIds;
      for (String postId in postIds) {
        deleting.add(Database.posts.doc(postId).delete());
      }

      await Future.wait(deleting);

      await Database.courses.doc(courseId).update({
        'professors': [],
        'tas': [],
        'groups': [],
        'tutorials': [],
        'posts': []
      });
    }
  }

  Future clearCourseList(List<String> courseIds) async {
    UserType currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    List<Future> clearing = [];
    for (String courseId in courseIds) {
      clearing.add(clearCourse(courseId));
    }

    await Future.wait(clearing);
  }

  Future clearAllCoursesData() async {
    UserType currentUserType = await _user.getCurrentUserType();
    if (currentUserType != UserType.admin) return;
    await Future.wait([
      Database.deleteAllAnnouncements(),
      Database.deleteAllAssignments(),
      Database.deleteAllCompensationLectures(),
      Database.deleteAllCompensationTutorials(),
      Database.deleteAllGroups(),
      Database.deleteAllPosts(),
      Database.deleteAllQuizzes(),
      Database.deleteAllTutorials(),
      Database.clearAllCourses(),
      Database.clearAllUserData()
    ]);
  }
}
