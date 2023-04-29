import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/models/notification_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class NotificationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createNotification(
      List<String> userIds,
      String? courseName,
      String title,
      String body,
      String eventId,
      NotificationType notificationType) async {
    final docNotification = Database.notifications.doc();

    final notification = NotificationModel(
        id: docNotification.id,
        courseName: courseName,
        title: title,
        body: body,
        createdAt: DateTime.now(),
        eventId: eventId,
        notificationType: notificationType);

    final json = notification.toJson();

    await docNotification.set(json);

    final userNotification =
        UserNotification(id: docNotification.id, seen: false);

    List<Future> updates = [];

    for (String userId in userIds) {
      UserModel? user = await Database.getUser(userId);
      if (user != null) {
        if (user.notifications.isEmpty) {
          user.notifications.add(userNotification);
          updates.add(Database.users.doc(userId).update({
            'notifications':
                user.notifications.map((notification) => notification.toJson())
          }));
        } else {
          updates.add(Database.users.doc(userId).update({
            'notifications': FieldValue.arrayUnion([userNotification.toJson()])
          }));
        }
      }
    }

    await Future.wait(updates);
  }

  Future markNotificationAsSeen(String notificationId) async {
    UserModel? currentUser =
        await Database.getUser(_auth.currentUser?.uid ?? '');
    if (currentUser != null) {
      currentUser.notifications
          .removeWhere((notification) => notification.id == notificationId);
      currentUser.notifications
          .add(UserNotification(id: notificationId, seen: true));

      await Database.users.doc(_auth.currentUser?.uid).update({
        'notifications': currentUser.notifications
            .map((notification) => notification.toJson())
      });
    }
  }

  Future<List<NotificationDisplay>> getMyNotifications() async {
    UserModel? currentUser =
        await Database.getUser(_auth.currentUser?.uid ?? '');
    if (currentUser != null) {
      List<NotificationDisplay> notifications =
          await Database.getNotificationListFromUserNotifications(
              currentUser.notifications);

      notifications.sort(((NotificationDisplay a, NotificationDisplay b) =>
          b.notification.createdAt.compareTo(a.notification.createdAt)));

      return notifications;
    }
    return [];
  }

  Future<DisplayEvent?> getDisplayEventFromNotification(
      String eventId, NotificationType notificationType) async {
    switch (notificationType) {
      case NotificationType.post:
        return null;
      case NotificationType.reply:
        return null;

      case NotificationType.announcement:
        Announcement? announcement = await Database.getAnnouncement(eventId);
        if (announcement != null) {
          return DisplayEvent.fromAnnouncement(announcement);
        }
        return null;

      case NotificationType.assignment:
        Assignment? assignment = await Database.getAssignment(eventId);
        if (assignment != null) {
          return DisplayEvent.fromAssignment(assignment);
        }
        return null;

      case NotificationType.quiz:
        Quiz? quiz = await Database.getQuiz(eventId);
        if (quiz != null) {
          return DisplayEvent.fromQuiz(quiz);
        }
        return null;

      case NotificationType.compensationLecture:
        CompensationLecture? compensationLecture =
            await Database.getCompensationLecture(eventId);
        if (compensationLecture != null) {
          return DisplayEvent.fromCompensationLecture(compensationLecture);
        }
        return null;

      case NotificationType.compensationTutorial:
        CompensationTutorial? compensationTutorial =
            await Database.getCompensationTutorial(eventId);
        if (compensationTutorial != null) {
          return DisplayEvent.fromCompensationTutorial(compensationTutorial);
        }
        return null;
    }
  }

  Future<Course?> getCourseFromNotification(
      String eventId, NotificationType notificationType) async {
    switch (notificationType) {
      case NotificationType.reply:
      case NotificationType.post:
        Post? post = await Database.getPost(eventId);
        if (post != null) {
          Course? course = await Database.getCourse(post.courseId);
          return course;
        }

        return null;

      case NotificationType.announcement:
        Announcement? announcement = await Database.getAnnouncement(eventId);
        if (announcement != null) {
          Course? course = await Database.getCourse(announcement.course);
          return course;
        }
        return null;

      case NotificationType.assignment:
        Assignment? assignment = await Database.getAssignment(eventId);
        if (assignment != null) {
          Course? course = await Database.getCourse(assignment.course);
          return course;
        }
        return null;

      case NotificationType.quiz:
        Quiz? quiz = await Database.getQuiz(eventId);
        if (quiz != null) {
          Course? course = await Database.getCourse(quiz.course);
          return course;
        }
        return null;

      case NotificationType.compensationLecture:
        CompensationLecture? compensationLecture =
            await Database.getCompensationLecture(eventId);
        if (compensationLecture != null) {
          Course? course = await Database.getCourse(compensationLecture.course);
          return course;
        }
        return null;

      case NotificationType.compensationTutorial:
        CompensationTutorial? compensationTutorial =
            await Database.getCompensationTutorial(eventId);
        if (compensationTutorial != null) {
          Course? course =
              await Database.getCourse(compensationTutorial.course);
          return course;
        }
        return null;
    }
  }
}
