import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
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
    return Column(
        children: events
            .map((event) => Column(children: [
                  EventCard(
                    title: event.title,
                    subtitle: event.subtitle,
                    description: event.description,
                    courseName: courseName,
                    file: event.file,
                  ),
                  Divider(
                    color: AppColors.unselected,
                  )
                ]))
            .toList());
  }
}
