import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/notification_model.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class NotificationCard extends StatefulWidget {
  final NotificationDisplay displayNotification;

  const NotificationCard({super.key, required this.displayNotification});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor:
          widget.displayNotification.seen ? AppColors.light : AppColors.newItem,
      title: Text(
        widget.displayNotification.notification.title,
        style: TextStyle(fontSize: Sizes.small),
      ),
      subtitle: Text(widget.displayNotification.notification.body),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => EventDetails(courseName: courseName, event: event)),
        // );
      },
    );
  }
}
