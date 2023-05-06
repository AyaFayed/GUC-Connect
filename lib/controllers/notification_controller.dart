import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/database/reads/announcement_reads.dart';
import 'package:guc_scheduling_app/database/reads/assignment_reads.dart';
import 'package:guc_scheduling_app/database/reads/course_reads.dart';
import 'package:guc_scheduling_app/database/reads/notification_reads.dart';
import 'package:guc_scheduling_app/database/reads/post_reads.dart';
import 'package:guc_scheduling_app/database/reads/scheduled_event_reads.dart';
import 'package:guc_scheduling_app/database/reads/user_reads.dart';
import 'package:guc_scheduling_app/database/writes/user_writes.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/models/notification/notification_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class NotificationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _user = UserController();
  final UserReads _userReads = UserReads();
  final UserWrites _userWrites = UserWrites();
  final NotificationReads _notificationReads = NotificationReads();
  final AssignmentReads _assignmentReads = AssignmentReads();
  final AnnouncementReads _announcementReads = AnnouncementReads();
  final PostReads _postReads = PostReads();
  final ScheduledEventReads _scheduledEventReads = ScheduledEventReads();
  final CourseReads _courseReads = CourseReads();

  Future createNotification(
      List<String> userIds,
      String? courseName,
      String title,
      String body,
      String eventId,
      NotificationType notificationType) async {
    final docNotification = DatabaseReferences.notifications.doc();

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

    UserNotification userNotification =
        UserNotification(id: docNotification.id, seen: false);

    List<Future> updates = [];

    for (String userId in userIds) {
      if (userId != _auth.currentUser?.uid) {
        UserModel? user = await _userReads.getUser(userId);
        if (user != null) {
          updates
              .add(_userWrites.addNotificationToUser(userId, userNotification));
        }
      }
    }

    await Future.wait(updates);
  }

  Future markNotificationAsSeen(String notificationId) async {
    UserModel? currentUser = await _user.getCurrentUser();
    if (currentUser != null) {
      currentUser.userNotifications
          .removeWhere((notification) => notification.id == notificationId);
      currentUser.userNotifications
          .add(UserNotification(id: notificationId, seen: true));

      await _userWrites.markNotificationAsSeen(
          currentUser.id, currentUser.userNotifications);
    }
  }

  Future<List<NotificationDisplay>> getMyNotifications() async {
    UserModel? currentUser = await _user.getCurrentUser();
    if (currentUser != null) {
      List<NotificationDisplay> notifications =
          await _notificationReads.getNotificationListFromUserNotifications(
              currentUser.userNotifications);

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
        Announcement? announcement =
            await _announcementReads.getAnnouncement(eventId);
        if (announcement != null) {
          return DisplayEvent.fromAnnouncement(announcement);
        }
        return null;

      case NotificationType.assignment:
        Assignment? assignment = await _assignmentReads.getAssignment(eventId);
        if (assignment != null) {
          return DisplayEvent.fromAssignment(assignment);
        }
        return null;

      case NotificationType.quiz:
      case NotificationType.compensationLecture:
      case NotificationType.compensationTutorial:
        ScheduledEvent? scheduledEvent =
            await _scheduledEventReads.getScheduledEvent(eventId);
        if (scheduledEvent != null) {
          return DisplayEvent.fromScheduledEvent(scheduledEvent);
        }
        return null;
    }
  }

  Future<Course?> getCourseFromNotification(
      String eventId, NotificationType notificationType) async {
    switch (notificationType) {
      case NotificationType.reply:
      case NotificationType.post:
        Post? post = await _postReads.getPost(eventId);
        if (post != null) {
          Course? course = await _courseReads.getCourse(post.courseId);
          return course;
        }

        return null;

      case NotificationType.announcement:
        Announcement? announcement =
            await _announcementReads.getAnnouncement(eventId);
        if (announcement != null) {
          Course? course = await _courseReads.getCourse(announcement.courseId);
          return course;
        }
        return null;

      case NotificationType.assignment:
        Assignment? assignment = await _assignmentReads.getAssignment(eventId);
        if (assignment != null) {
          Course? course = await _courseReads.getCourse(assignment.courseId);
          return course;
        }
        return null;

      case NotificationType.quiz:
      case NotificationType.compensationLecture:
      case NotificationType.compensationTutorial:
        ScheduledEvent? scheduledEvent =
            await _scheduledEventReads.getScheduledEvent(eventId);
        if (scheduledEvent != null) {
          Course? course =
              await _courseReads.getCourse(scheduledEvent.courseId);
          return course;
        }
        return null;
    }
  }
}
