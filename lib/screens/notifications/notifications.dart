import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/notification_controller.dart';
import 'package:guc_scheduling_app/models/notification_model.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/notification_widgets/notification_card.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationController _notificationController =
      NotificationController();

  List<NotificationDisplay>? _notifications;

  Future<void> _getData() async {
    List<NotificationDisplay> notifications =
        await _notificationController.getMyNotifications();

    setState(() {
      _notifications = notifications;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: _notifications == null
                ? const CircularProgressIndicator()
                : ListView.separated(
                    itemBuilder: (BuildContext context, int index) =>
                        NotificationCard(
                            displayNotification: _notifications![index]),
                    itemCount: _notifications!.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: AppColors.unselected,
                    ),
                  )));
  }
}
