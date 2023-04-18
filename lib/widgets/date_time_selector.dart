import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class DateTimeSelector extends StatefulWidget {
  final dynamic Function(DateTime) onConfirm;
  final DateTime? dateTime;
  const DateTimeSelector(
      {super.key, required this.onConfirm, required this.dateTime});

  @override
  State<DateTimeSelector> createState() => _SelectState();
}

class _SelectState extends State<DateTimeSelector> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        icon: const Icon(Icons.calendar_month),
        style: TextButton.styleFrom(iconColor: AppColors.dark),
        onPressed: () {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2038),
              onConfirm: widget.onConfirm,
              currentTime: DateTime.now(),
              locale: LocaleType.en);
        },
        label: Text(
          widget.dateTime == null
              ? Errors.dateTime
              : widget.dateTime.toString(),
          style: TextStyle(color: AppColors.dark),
        ));
  }
}
