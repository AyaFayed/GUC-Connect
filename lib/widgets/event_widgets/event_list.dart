import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_card.dart';

class EventList extends StatelessWidget {
  final List<DisplayEvent> events;
  final String courseName;

  const EventList({
    super.key,
    required this.events,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: events.map((DisplayEvent event) {
          return EventCard(
              title: event.title,
              subtitle: event.subtitle,
              description: event.description,
              courseName: courseName);
        }).toList());
  }
}
