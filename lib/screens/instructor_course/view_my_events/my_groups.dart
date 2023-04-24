import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/announcement_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/widgets/drawers/professor_drawer.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class MyGroups extends StatefulWidget {
  final String courseId;
  final String courseName;
  const MyGroups({super.key, required this.courseId, required this.courseName});

  @override
  State<MyGroups> createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  final AnnouncementController _announcementController =
      AnnouncementController();
  final UserController _userController = UserController();

  List<DisplayEvent>? _events;

  Future<void> _getData() async {
    List<Announcement> announcements =
        await _announcementController.getMyAnnouncements(widget.courseId);

    List<DisplayEvent> events =
        await Future.wait(announcements.map((Announcement announcement) async {
      UserType userType =
          await _userController.getUserType(announcement.creator);
      String instructorName =
          await _userController.getUserName(announcement.creator);
      return DisplayEvent(
          id: announcement.id,
          eventType: EventType.announcements,
          title: formatName(instructorName, userType),
          subtitle: announcement.title,
          description: announcement.description,
          file: announcement.file);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My groups'),
        elevation: 0.0,
      ),
      drawer: ProfessorDrawer(
          courseId: widget.courseId, courseName: widget.courseName, pop: true),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: _events == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: EventList(
                  events: _events ?? [],
                  courseName: widget.courseName,
                ))),
    );
  }
}
