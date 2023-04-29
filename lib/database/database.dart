import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/models/notification_model.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class Database {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> courses =
      database.collection('courses');
  static CollectionReference<Map<String, dynamic>> users =
      database.collection('users');
  static CollectionReference<Map<String, dynamic>> groups =
      database.collection('groups');
  static CollectionReference<Map<String, dynamic>> tutorials =
      database.collection('tutorials');
  static CollectionReference<Map<String, dynamic>> announcements =
      database.collection('announcements');
  static CollectionReference<Map<String, dynamic>> assignments =
      database.collection('assignments');
  static CollectionReference<Map<String, dynamic>> compensationLectures =
      database.collection('compensationLectures');
  static CollectionReference<Map<String, dynamic>> compensationTutorials =
      database.collection('compensationTutorials');
  static CollectionReference<Map<String, dynamic>> quizzes =
      database.collection('quizzes');
  static CollectionReference<Map<String, dynamic>> posts =
      database.collection('posts');
  static CollectionReference<Map<String, dynamic>> notifications =
      database.collection('notifications');

  static Future<Map<String, dynamic>?> getDocumentData(
      CollectionReference<Map<String, dynamic>> docRef, String? docId) async {
    final doc = docRef.doc(docId);
    final snapshot = await doc.get();

    if (snapshot.exists) {
      return snapshot.data();
    }
    return null;
  }

  static Future<Course?> getCourse(String courseId) async {
    final courseData = await getDocumentData(courses, courseId);
    if (courseData != null) {
      Course course = Course.fromJson(courseData);
      return course;
    }
    return null;
  }

  static Future<Post?> getPost(String postId) async {
    final postData = await getDocumentData(posts, postId);
    if (postData != null) {
      Post post = Post.fromJson(postData);
      return post;
    }
    return null;
  }

  static Future<NotificationModel?> getNotification(
      String notificationId) async {
    final notificationData =
        await getDocumentData(notifications, notificationId);
    if (notificationData != null) {
      NotificationModel notification =
          NotificationModel.fromJson(notificationData);
      return notification;
    }
    return null;
  }

  static Future<NotificationDisplay?> getDisplayNotification(
      UserNotification userNotification) async {
    final notificationData =
        await getDocumentData(notifications, userNotification.id);

    if (notificationData != null) {
      NotificationModel notification =
          NotificationModel.fromJson(notificationData);
      NotificationDisplay notificationDisplay = NotificationDisplay(
          notification: notification, seen: userNotification.seen);
      return notificationDisplay;
    }
    return null;
  }

  static Future<UserModel?> getUser(String userId) async {
    final userIdData = await getDocumentData(users, userId);
    if (userIdData != null) {
      UserModel user = UserModel.fromJson(userIdData);
      return user;
    }
    return null;
  }

  static Future<Student?> getStudent(String studentId) async {
    final studentData = await getDocumentData(users, studentId);
    if (studentData != null) {
      try {
        Student student = Student.fromJson(studentData);
        return student;
      } catch (e) {
        print(e);
        return null;
      }
    }
    return null;
  }

  static Future<Professor?> getProfessor(String professorId) async {
    final professorData = await getDocumentData(users, professorId);
    if (professorData != null) {
      try {
        Professor professor = Professor.fromJson(professorData);
        return professor;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<TA?> getTa(String taId) async {
    final taData = await getDocumentData(users, taId);
    if (taData != null) {
      try {
        TA ta = TA.fromJson(taData);
        return ta;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<Group?> getGroup(String groupId) async {
    final groupData = await getDocumentData(groups, groupId);
    if (groupData != null) {
      Group group = Group.fromJson(groupData);
      return group;
    }
    return null;
  }

  static Future<Tutorial?> getTutorial(String tutorialId) async {
    final tutorialData = await getDocumentData(tutorials, tutorialId);
    if (tutorialData != null) {
      Tutorial tutorial = Tutorial.fromJson(tutorialData);
      return tutorial;
    }
    return null;
  }

  static Future<Announcement?> getAnnouncement(String announcementId) async {
    final announcementData =
        await getDocumentData(announcements, announcementId);
    if (announcementData != null) {
      Announcement announcement = Announcement.fromJson(announcementData);
      return announcement;
    }
    return null;
  }

  static Future<Assignment?> getAssignment(String assignmentId) async {
    final assignmentData = await getDocumentData(assignments, assignmentId);
    if (assignmentData != null) {
      Assignment assignment = Assignment.fromJson(assignmentData);
      return assignment;
    }
    return null;
  }

  static Future<Quiz?> getQuiz(String quizId) async {
    final quizData = await getDocumentData(quizzes, quizId);
    if (quizData != null) {
      Quiz quiz = Quiz.fromJson(quizData);
      return quiz;
    }
    return null;
  }

  static Future<CompensationLecture?> getCompensationLecture(
      String compensationLectureId) async {
    final compensationLectureData =
        await getDocumentData(compensationLectures, compensationLectureId);
    if (compensationLectureData != null) {
      CompensationLecture compensationLecture =
          CompensationLecture.fromJson(compensationLectureData);
      return compensationLecture;
    }
    return null;
  }

  static Future<CompensationTutorial?> getCompensationTutorial(
      String compensationTutorialId) async {
    final compensationTutorialData =
        await getDocumentData(compensationTutorials, compensationTutorialId);
    if (compensationTutorialData != null) {
      CompensationTutorial compensationTutorial =
          CompensationTutorial.fromJson(compensationTutorialData);
      return compensationTutorial;
    }
    return null;
  }

  static Future<List<Group>> getAllGroups() async {
    QuerySnapshot querySnapshot = await groups.get();

    List<Group> allGroups = querySnapshot.docs
        .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allGroups;
  }

  static Future<List<Tutorial>> getAllTutorials() async {
    QuerySnapshot querySnapshot = await tutorials.get();

    List<Tutorial> allTutorials = querySnapshot.docs
        .map((doc) => Tutorial.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allTutorials;
  }

  static Future<List<Course>> getAllCourses() async {
    QuerySnapshot querySnapshot = await courses.get();

    List<Course> allCourses = querySnapshot.docs
        .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allCourses;
  }

  static Future<List<Announcement>> getAllAnnouncements() async {
    QuerySnapshot querySnapshot = await announcements.get();

    List<Announcement> allAnnouncements = querySnapshot.docs
        .map((doc) => Announcement.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allAnnouncements;
  }

  static Future<List<Assignment>> getAllAssignments() async {
    QuerySnapshot querySnapshot = await assignments.get();

    List<Assignment> allAssignments = querySnapshot.docs
        .map((doc) => Assignment.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allAssignments;
  }

  static Future<List<Quiz>> getAllQuizzes() async {
    QuerySnapshot querySnapshot = await quizzes.get();

    List<Quiz> allQuizzes = querySnapshot.docs
        .map((doc) => Quiz.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allQuizzes;
  }

  static Future<List<CompensationLecture>> getAllCompensationLectures() async {
    QuerySnapshot querySnapshot = await compensationLectures.get();

    List<CompensationLecture> allCompensationLectures = querySnapshot.docs
        .map((doc) =>
            CompensationLecture.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allCompensationLectures;
  }

  static Future<List<CompensationTutorial>>
      getAllCompensationTutorials() async {
    QuerySnapshot querySnapshot = await compensationTutorials.get();

    List<CompensationTutorial> allCompensationTutorials = querySnapshot.docs
        .map((doc) =>
            CompensationTutorial.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allCompensationTutorials;
  }

  static Future<List<Quiz>> getQuizListFromIds(List<String> eventIds) async {
    List<Quiz?> quizzesNull = await Future.wait(eventIds.map((String eventId) {
      return Database.getQuiz(eventId);
    }));

    List<Quiz> quizzes = [];

    for (Quiz? quiz in quizzesNull) {
      if (quiz != null) {
        quizzes.add(quiz);
      }
    }
    return quizzes;
  }

  static Future<List<Announcement>> getAnnouncementListFromIds(
      List<String> eventIds) async {
    List<Announcement?> announcementsNull =
        await Future.wait(eventIds.map((String eventId) {
      return Database.getAnnouncement(eventId);
    }));

    List<Announcement> announcements = [];

    for (Announcement? announcement in announcementsNull) {
      if (announcement != null) {
        announcements.add(announcement);
      }
    }
    return announcements;
  }

  static Future<List<Assignment>> getAssignmentListFromIds(
      List<String> eventIds) async {
    List<Assignment?> assignmentsNull =
        await Future.wait(eventIds.map((String eventId) {
      return Database.getAssignment(eventId);
    }));

    List<Assignment> assignments = [];

    for (Assignment? assignment in assignmentsNull) {
      if (assignment != null) {
        assignments.add(assignment);
      }
    }
    return assignments;
  }

  static Future<List<CompensationLecture>> getCompensationLectureListFromIds(
      List<String> eventIds) async {
    List<CompensationLecture?> compensationLecturesNull =
        await Future.wait(eventIds.map((String eventId) {
      return Database.getCompensationLecture(eventId);
    }));

    List<CompensationLecture> compensationLectures = [];

    for (CompensationLecture? compensationLecture in compensationLecturesNull) {
      if (compensationLecture != null) {
        compensationLectures.add(compensationLecture);
      }
    }
    return compensationLectures;
  }

  static Future<List<CompensationTutorial>> getCompensationTutorialListFromIds(
      List<String> eventIds) async {
    List<CompensationTutorial?> compensationTutorialsNull =
        await Future.wait(eventIds.map((String eventId) {
      return Database.getCompensationTutorial(eventId);
    }));

    List<CompensationTutorial> compensationTutorials = [];

    for (CompensationTutorial? compensationTutorial
        in compensationTutorialsNull) {
      if (compensationTutorial != null) {
        compensationTutorials.add(compensationTutorial);
      }
    }
    return compensationTutorials;
  }

  static Future<List<Group>> getGroupListFromIds(List<String> ids) async {
    List<Group?> groupsNull = await Future.wait(ids.map((String id) {
      return Database.getGroup(id);
    }));

    List<Group> groups = [];
    for (Group? group in groupsNull) {
      if (group != null) {
        groups.add(group);
      }
    }

    return groups;
  }

  static Future<List<Tutorial>> getTutorialListFromIds(List<String> ids) async {
    List<Tutorial?> tutorialsNull = await Future.wait(ids.map((String id) {
      return Database.getTutorial(id);
    }));

    List<Tutorial> tutorials = [];
    for (Tutorial? tutorial in tutorialsNull) {
      if (tutorial != null) {
        tutorials.add(tutorial);
      }
    }
    return tutorials;
  }

  static Future<List<Course>> getCourseListFromIds(List<String> ids) async {
    List<Course?> coursesNull = await Future.wait(ids.map((String id) {
      return Database.getCourse(id);
    }));

    List<Course> courses = [];
    for (Course? course in coursesNull) {
      if (course != null) {
        courses.add(course);
      }
    }
    return courses;
  }

  static Future<List<Post>> getPostListFromIds(List<String> ids) async {
    List<Post?> postsNull = await Future.wait(ids.map((String id) {
      return Database.getPost(id);
    }));
    List<Post> posts = [];
    for (Post? post in postsNull) {
      if (post != null) {
        posts.add(post);
      }
    }
    return posts;
  }

  static Future<List<NotificationDisplay>>
      getNotificationListFromUserNotifications(
          List<UserNotification> userNotifications) async {
    List<NotificationDisplay?> notificationsNull = await Future.wait(
        userNotifications.map((UserNotification userNotification) {
      return Database.getDisplayNotification(userNotification);
    }));

    List<NotificationDisplay> notifications = [];
    for (NotificationDisplay? notification in notificationsNull) {
      if (notification != null) {
        notifications.add(notification);
      }
    }
    return notifications;
  }

  static Future deleteAllGroups() async {
    QuerySnapshot querySnapshot = await groups.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  static Future deleteAllTutorials() async {
    QuerySnapshot querySnapshot = await tutorials.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  static Future deleteAllAnnouncements() async {
    QuerySnapshot querySnapshot = await announcements.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  static Future deleteAllAssignments() async {
    QuerySnapshot querySnapshot = await assignments.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  static Future deleteAllQuizzes() async {
    QuerySnapshot querySnapshot = await quizzes.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  static Future deleteAllCompensationLectures() async {
    QuerySnapshot querySnapshot = await compensationLectures.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  static Future deleteAllCompensationTutorials() async {
    QuerySnapshot querySnapshot = await compensationTutorials.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  static Future deleteAllPosts() async {
    QuerySnapshot querySnapshot = await posts.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  static Future clearAllCourses() async {
    QuerySnapshot querySnapshot = await courses.get();
    await Future.wait(querySnapshot.docs
        .map((doc) => doc.reference.update({
              'professors': [],
              'tas': [],
              'groups': [],
              'tutorials': [],
              'posts': []
            }))
        .toList());
  }

  static Future clearAllUserData() async {
    QuerySnapshot querySnapshot = await users.get();

    await Future.wait(querySnapshot.docs
        .map((doc) => doc.reference.update({'courses': []}))
        .toList());
  }

  static Future<List<String>> getDivisionStudentIds(
      String divisionId, DivisionType divisionType) async {
    final divisionData = await getDocumentData(
        divisionType == DivisionType.groups ? groups : tutorials, divisionId);
    if (divisionData != null) {
      return (divisionData['students'] as List<dynamic>).cast<String>();
    }
    return [];
  }

  static Future<List<String>> getDivisionsStudentIds(
      List<String> divisionIds, DivisionType divisionType) async {
    List<Future<List<String>>> studentIdListsFuture = [];
    for (String divisionId in divisionIds) {
      studentIdListsFuture.add(getDivisionStudentIds(divisionId, divisionType));
    }

    List<List<String>> studentIdLists = await Future.wait(studentIdListsFuture);

    List<String> studentIds = [];

    for (List<String> list in studentIdLists) {
      studentIds.addAll(list);
    }

    return studentIds;
  }
}
