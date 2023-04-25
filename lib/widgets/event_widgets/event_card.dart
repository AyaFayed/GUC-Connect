import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/screens/event/edit_event.dart';
import 'package:guc_scheduling_app/screens/event/event_details.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class EventCard extends StatelessWidget {
  final String courseName;
  final DisplayEvent event;
  final bool? editable;
  final Future<void> Function()? getData;

  const EventCard({
    super.key,
    required this.event,
    this.editable,
    required this.courseName,
    this.getData,
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
              builder: (context) => editable == true
                  ? EditEvent(
                      courseName: courseName,
                      eventId: event.id,
                      eventType: event.eventType,
                      getData: getData!,
                    )
                  : EventDetails(courseName: courseName, event: event)),
        );
      },
    );
  }
}
