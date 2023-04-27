import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 31)),
      lastDay: DateTime.utc(2037, 3, 14),
      focusedDay: DateTime.now(),
    );
  }
}
