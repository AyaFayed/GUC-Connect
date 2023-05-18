import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/scheduled_event_controller.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/widgets/drawers/professor_drawer.dart';
import 'package:guc_scheduling_app/widgets/drawers/ta_drawer.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class MyScheduledEvents extends StatefulWidget {
  final String courseId;
  final String courseName;
  final EventType eventType;
  const MyScheduledEvents({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.eventType,
  });

  @override
  State<MyScheduledEvents> createState() => _MyScheduledEventsState();
}

class _MyScheduledEventsState extends State<MyScheduledEvents> {
  final ScheduledEventsController _scheduledEventsController =
      ScheduledEventsController();

  List<DisplayEvent>? _events;

  Future<void> _getData() async {
    List<ScheduledEvent> scheduledEvents = await _scheduledEventsController
        .getMyScheduledEvents(widget.courseId, widget.eventType);

    List<DisplayEvent> events =
        scheduledEvents.map((ScheduledEvent scheduledEvent) {
      return DisplayEvent.fromScheduledEvent(scheduledEvent);
    }).toList();

    setState(() {
      _events = events;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scheduled ${formatEventTypePlural(widget.eventType)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
      ),
      drawer: widget.eventType == EventType.compensationTutorial
          ? TADrawer(
              courseId: widget.courseId,
              courseName: widget.courseName,
              pop: true)
          : ProfessorDrawer(
              courseId: widget.courseId,
              courseName: widget.courseName,
              pop: true),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: _events == null
              ? const Center(child: CircularProgressIndicator())
              : _events!.isEmpty
                  ? Text(
                      "You haven't scheduled any ${formatEventTypePlural(widget.eventType)} yet.")
                  : SingleChildScrollView(
                      child: EventList(
                      events: _events ?? [],
                      courseName: widget.courseName,
                      editable: true,
                      getData: _getData,
                    ))),
    );
  }
}
