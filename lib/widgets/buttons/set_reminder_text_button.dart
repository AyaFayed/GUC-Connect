import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/screens/event/set_reminder.dart';
import 'package:guc_scheduling_app/widgets/buttons/large__icon_btn.dart';

class SetReminderButton extends StatefulWidget {
  final String title;
  final String eventId;
  const SetReminderButton(
      {super.key, required this.title, required this.eventId});

  @override
  State<SetReminderButton> createState() => _SetReminderButtonState();
}

class _SetReminderButtonState extends State<SetReminderButton> {
  Future<void> setReminder() async {}

  @override
  Widget build(BuildContext context) {
    return LargeIconBtn(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SetReminder(
                    title: widget.title,
                    eventId: widget.eventId,
                  )),
        );
      },
      color: AppColors.confirm,
      icon: const Icon(Icons.alarm),
      text: widget.title,
    );
  }
}
