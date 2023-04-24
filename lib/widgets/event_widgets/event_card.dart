import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/screens/event/event_details.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class EventCard extends StatelessWidget {
  final String courseName;
  final DisplayEvent event;
  final bool? editable;

  const EventCard({
    super.key,
    required this.event,
    this.editable,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        event.title,
        style: TextStyle(fontSize: Sizes.small),
      ),
      subtitle: Text(
        event.subtitle,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EventDetails(courseName: courseName, event: event)),
        );
      },
    );
  }
}
