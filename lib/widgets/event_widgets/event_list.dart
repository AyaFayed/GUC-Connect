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
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => EventCard(
            title: events[index].title,
            subtitle: events[index].subtitle,
            description: events[index].description,
            courseName: courseName),
        itemCount: events.length,
        separatorBuilder: (BuildContext context, int index) => Divider(
              color: AppColors.unselected,
            ));
  }
}
