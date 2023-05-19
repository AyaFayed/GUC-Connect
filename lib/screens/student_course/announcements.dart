import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/announcement_controller.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class Announcements extends StatefulWidget {
  final String courseId;
  final String courseName;
  const Announcements(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  final AnnouncementController _announcementController =
      AnnouncementController();

  List<DisplayEvent>? _events;

  Future<void> _getData() async {
    List<Announcement> announcements =
        await _announcementController.getCourseAnnouncements(widget.courseId);

    List<DisplayEvent> events =
        await Future.wait(announcements.map((Announcement announcement) async {
      return DisplayEvent.fromAnnouncement(announcement);
    }));
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
