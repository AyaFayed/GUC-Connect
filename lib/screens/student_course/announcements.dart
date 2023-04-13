import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/announcement_controller.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';

class Announcements extends StatefulWidget {
  final String courseId;
  const Announcements({super.key, required this.courseId});

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  AnnouncementController _announcementController = AnnouncementController();

  List<Announcement>? _announcements;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<Announcement> announcementsData =
        await _announcementController.getCourseAnnouncements(widget.courseId);

    setState(() {
      _announcements = announcementsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
