import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/screens/event/event_details.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class GroupCalendarEventCard extends StatelessWidget {
  final String courseName;
  final DisplayEvent event;
  final int studentsCount;

  const GroupCalendarEventCard({
    super.key,
    required this.event,
    required this.courseName,
    required this.studentsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      child: ListTile(
        title: Text(
          formatEventTypeAndCapitalizeFirstLetter(event.eventType),
          style: TextStyle(fontSize: Sizes.small),
        ),
        subtitle: Text(
          event.subtitle,
        ),
        trailing: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.person,
                  color: AppColors.unselected,
                ),
              ),
              TextSpan(
                  text: studentsCount.toString(),
                  style: TextStyle(
                    color: AppColors.unselected,
                    fontSize: Sizes.smaller,
                  )),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EventDetails(courseName: courseName, event: event)),
          );
        },
      ),
    );
  }
}
