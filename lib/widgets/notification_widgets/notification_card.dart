import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/notification_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/notification_model.dart';
import 'package:guc_scheduling_app/screens/event/event_details.dart';
import 'package:guc_scheduling_app/screens/instructor_course/professor_course.dart';
import 'package:guc_scheduling_app/screens/instructor_course/ta_course.dart';
import 'package:guc_scheduling_app/screens/student_course/student_course.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class NotificationCard extends StatefulWidget {
  final NotificationDisplay displayNotification;

  const NotificationCard({super.key, required this.displayNotification});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  final NotificationController _notificationController =
      NotificationController();
  final UserController _userController = UserController();

  Future<void> redirect() async {
    UserType currentUserType = await _userController.getCurrentUserType();
    if (widget.displayNotification.notification.notificationType ==
            NotificationType.post ||
        widget.displayNotification.notification.notificationType ==
            NotificationType.reply) {
      Course? course = await _notificationController.getCourseFromNotification(
          widget.displayNotification.notification.eventId,
          widget.displayNotification.notification.notificationType);
      if (context.mounted) {
        switch (currentUserType) {
          case UserType.student:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentCourse(
                        courseId: course?.id ?? '',
                        courseName: course?.name ?? '',
                        selectedIndex: 3,
                      )),
            );
            break;
          case UserType.ta:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TACourse(
                        courseId: course?.id ?? '',
                        courseName: course?.name ?? '',
                        selectedIndex: 3,
                      )),
            );
            break;
          case UserType.professor:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfessorCourse(
                        courseId: course?.id ?? '',
                        courseName: course?.name ?? '',
                        selectedIndex: 3,
                      )),
            );
            break;
          case UserType.admin:
            break;
        }
      }
    } else {
      DisplayEvent? displayEvent =
          await _notificationController.getDisplayEventFromNotification(
              widget.displayNotification.notification.eventId,
              widget.displayNotification.notification.notificationType);
      if (context.mounted) {
        print(displayEvent);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventDetails(
                  courseName:
                      widget.displayNotification.notification.courseName ?? '',
                  event: displayEvent)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.displayNotification.notification.title,
        style: TextStyle(
          fontSize: Sizes.small,
          fontWeight: widget.displayNotification.seen
              ? FontWeight.normal
              : FontWeight.bold,
        ),
      ),
      subtitle: Text(widget.displayNotification.notification.body),
      onTap: () async {
        await _notificationController
            .markNotificationAsSeen(widget.displayNotification.notification.id);
        setState(() {
          widget.displayNotification.seen = true;
        });
        await redirect();
      },
    );
  }
}
