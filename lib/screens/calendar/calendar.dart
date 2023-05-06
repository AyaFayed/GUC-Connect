import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/callendar_events_controller.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/calendar_event_card.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarEventsController _calendarEventsController =
      CalendarEventsController();
  DateTime selectedDay = DateTime.now();

  Map<DateTime, List<CalendarEvent>>? _allEvents;
  List<CalendarEvent> selectedEvents = [];

  List<CalendarEvent> getEventsfromDay(DateTime date) {
    return _allEvents?[DateTime(date.year, date.month, date.day)] ?? [];
  }

  Future<void> _getData() async {
    Map<DateTime, List<CalendarEvent>> eventsData =
        await _calendarEventsController.getMyCalendarEvents();
    setState(() {
      _allEvents = eventsData;
      selectedEvents = getEventsfromDay(selectedDay);
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
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: SingleChildScrollView(
          child: _allEvents == null
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    TableCalendar(
                      focusedDay: selectedDay,
                      firstDay:
                          DateTime.now().subtract(const Duration(days: 31)),
                      lastDay: DateTime.utc(2037, 3, 14),
                      calendarFormat: CalendarFormat.month,
                      startingDayOfWeek: StartingDayOfWeek.saturday,
                      daysOfWeekVisible: true,

                      //Day Changed
                      onDaySelected: (DateTime selectDay, DateTime focusDay) {
                        setState(() {
                          selectedDay = selectDay;
                          selectedEvents = getEventsfromDay(selectDay);
                        });
                      },

                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(selectedDay, date);
                      },

                      eventLoader: getEventsfromDay,

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
                    const SizedBox(
                      height: 20,
                    ),
                    ...selectedEvents.map((CalendarEvent item) =>
                        CalendarEventCard(
                            event: item.event, courseName: item.courseName)),
                  ],
                ),
        ),
      ),
    );
  }
}
