import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final EventsControllerHelper _eventsController = EventsControllerHelper();
  DateTime _selectedDay = DateTime.now();

  Map<DateTime, List<CalendarEvent>>? _events;

  List<CalendarEvent> event = [];
  List<CalendarEvent> _getEventsfromDay(DateTime date) {
    return _events?[date] ?? [];
  }

  Future<void> _getData() async {
    Map<DateTime, List<CalendarEvent>> eventsData =
        await _eventsController.getMyCalendarEvents();
    setState(() {
      _events = eventsData;
      eventsData.forEach((key, value) => event.addAll(value));
      print(_events);
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.now().subtract(const Duration(days: 31)),
            lastDay: DateTime.utc(2037, 3, 14),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.saturday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                _selectedDay = selectDay;
              });
            },

            selectedDayPredicate: (DateTime date) {
              return isSameDay(_selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.dark,
                  width: 2.0,
                ),
                color: Colors.transparent,
              ),
              selectedTextStyle: const TextStyle(color: Colors.black),
              todayTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.dark,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          ...event.map(
            (CalendarEvent e) => ListTile(
              title: Text('jjj'),
            ),
          ),
        ],
      ),
    );
  }
}
