import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/event/event_details.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String courseName;
  final String? file;

  const EventCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.courseName,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: Sizes.small),
      ),
      subtitle: Text(
        subtitle,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventDetails(
                    title: title,
                    subtitle: subtitle,
                    description: description,
                    courseName: courseName,
                    file: file,
                  )),
        );
      },
    );
  }
}
