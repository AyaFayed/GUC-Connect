import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/calendar_events_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/drawers/professor_drawer.dart';
import 'package:guc_scheduling_app/widgets/drawers/ta_drawer.dart';
import 'package:guc_scheduling_app/widgets/dropdowns/groups_dropdown.dart';
import 'package:guc_scheduling_app/widgets/dropdowns/tutorials_dropdown.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/calendar_event_card.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/group_calendar_event_card.dart';
import 'package:table_calendar/table_calendar.dart';

class GroupSchedules extends StatefulWidget {
  final String courseId;
  final String courseName;
  const GroupSchedules(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<GroupSchedules> createState() => _GroupSchedulesState();
}

class _GroupSchedulesState extends State<GroupSchedules> {
  final CalendarEventsController _calendarEventsController =
      CalendarEventsController();
  final UserController _userController = UserController();
  DateTime selectedDay = DateTime.now();
  final List<String> selectedGroupIds = [];

  Map<DateTime, List<CourseCalendarEvent>>? _allEvents;
  UserType? _currentUserType;
  List<CourseCalendarEvent> selectedEvents = [];

  List<CourseCalendarEvent> getEventsfromDay(DateTime date) {
    return _allEvents?[DateTime(date.year, date.month, date.day)] ?? [];
  }

  Future<void> updateCalendar() async {
    setState(() {
      _allEvents = null;
    });

    Map<DateTime, List<CourseCalendarEvent>> eventsData =
        await _calendarEventsController
            .getGroupCalendarEvents(selectedGroupIds);

    setState(() {
      _allEvents = eventsData;
      selectedEvents = getEventsfromDay(selectedDay);
    });
  }

  Future<void> _getData() async {
    await updateCalendar();

    UserType? currentUserType = await _userController.getCurrentUserType();
    setState(() {
      _currentUserType = currentUserType;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return _currentUserType == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Groups Schedules',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0.0,
            ),
            drawer: _currentUserType == UserType.professor
                ? ProfessorDrawer(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                    pop: true)
                : TADrawer(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                    pop: true),
            body: RefreshIndicator(
                onRefresh: _getData,
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      child: Column(
                        children: [
                          _currentUserType == UserType.professor
                              ? GroupsDropdown(
                                  courseId: widget.courseId,
                                  selectedGroupIds: selectedGroupIds,
                                  onConfirm: updateCalendar,
                                )
                              : TutorialsDropdown(
                                  courseId: widget.courseId,
                                  selectedTutorialIds: selectedGroupIds,
                                  onConfirm: updateCalendar,
                                ),
                          _allEvents == null
                              ? const CircularProgressIndicator()
                              : Column(
                                  children: [
                                    TableCalendar(
                                      focusedDay: selectedDay,
                                      firstDay: DateTime.now()
                                          .subtract(const Duration(days: 31)),
                                      lastDay: DateTime.utc(2037, 3, 14),
                                      calendarFormat: CalendarFormat.month,
                                      startingDayOfWeek:
                                          StartingDayOfWeek.saturday,
                                      daysOfWeekVisible: true,

                                      //Day Changed
                                      onDaySelected: (DateTime selectDay,
                                          DateTime focusDay) {
                                        setState(() {
                                          selectedDay = selectDay;
                                          selectedEvents =
                                              getEventsfromDay(selectDay);
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
                                        selectedTextStyle: const TextStyle(
                                            color: Colors.black),
                                        todayTextStyle: const TextStyle(
                                            color: Colors.white),
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
                                    ...selectedEvents.map(
                                        (CourseCalendarEvent item) =>
                                            GroupCalendarEventCard(
                                              event: item.event,
                                              courseName: item.courseName,
                                              studentsCount: item.stdentsCount,
                                            )),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
  }
}
