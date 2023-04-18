import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/announcement_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
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
  final UserController _userController = UserController();

  List<DisplayEvent>? _events;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<Announcement> announcements =
        await _announcementController.getCourseAnnouncements(widget.courseId);

    List<DisplayEvent> events =
        await Future.wait(announcements.map((Announcement announcement) async {
      UserType userType =
          await _userController.getUserType(announcement.creator);
      String instructorName =
          await _userController.getUserName(announcement.creator);
      return DisplayEvent(
          title:
              '${userType == UserType.professor ? 'Dr.' : 'Ta.'} $instructorName',
          subtitle: announcement.title,
          description: announcement.description,
          files: announcement.files);
    }));
    setState(() {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: _events == null
            ? const Center(child: CircularProgressIndicator())
            : EventList(
                events: _events ?? [],
                courseName: widget.courseName,
              ));
  }
}
