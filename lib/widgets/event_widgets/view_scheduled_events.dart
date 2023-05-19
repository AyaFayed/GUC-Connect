import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/scheduled_event_controller.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class ViewScheduledEvents extends StatefulWidget {
  final String courseId;
  final String courseName;
  final EventType eventType;
  const ViewScheduledEvents(
      {super.key,
      required this.courseId,
      required this.courseName,
      required this.eventType});

  @override
  State<ViewScheduledEvents> createState() => _ViewScheduledEventsState();
}

class _ViewScheduledEventsState extends State<ViewScheduledEvents> {
  final ScheduledEventsController _scheduledEventsController =
      ScheduledEventsController();

  List<DisplayEvent>? _events;

  Future<void> _getData() async {
    List<ScheduledEvent> scheduledEvents = await _scheduledEventsController
        .getCourseScheduledEvents(widget.courseId, widget.eventType);

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
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: _events == null
            ? const Center(child: CircularProgressIndicator())
            : _events!.isEmpty
                ? const Image(image: AssetImage('assets/images/no_data.png'))
                : EventList(
                    events: _events ?? [],
                    courseName: widget.courseName,
                    getData: _getData));
  }
}
