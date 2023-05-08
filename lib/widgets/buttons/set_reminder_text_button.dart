import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/screens/event/set_reminder.dart';

class SetReminderTextButton extends StatefulWidget {
  final String title;
  final String eventId;
  const SetReminderTextButton(
      {super.key, required this.title, required this.eventId});

  @override
  State<SetReminderTextButton> createState() => _SetReminderTextButtonState();
}

class _SetReminderTextButtonState extends State<SetReminderTextButton> {
  Future<void> setReminder() async {}

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SetReminder(
                      title: widget.title,
                      eventId: widget.eventId,
                    )),
          );
        },
        icon: const Icon(Icons.alarm),
        label: Text(
          widget.title,
          style: TextStyle(fontSize: Sizes.small),
        ));
  }
}
