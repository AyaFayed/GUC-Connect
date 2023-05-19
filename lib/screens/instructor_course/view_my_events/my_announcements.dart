import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/announcement_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/events/announcement_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/drawers/professor_drawer.dart';
import 'package:guc_scheduling_app/widgets/drawers/ta_drawer.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class MyAnnouncements extends StatefulWidget {
  final String courseId;
  final String courseName;
  const MyAnnouncements(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<MyAnnouncements> createState() => _MyAnnouncementsState();
}

class _MyAnnouncementsState extends State<MyAnnouncements> {
  final AnnouncementController _announcementController =
      AnnouncementController();
  final UserController _userController = UserController();

  List<DisplayEvent>? _events;
  UserType? _currentUserType;

  Future<void> _getData() async {
    List<Announcement> announcements =
        await _announcementController.getMyAnnouncements(widget.courseId);

    List<DisplayEvent> events =
        await Future.wait(announcements.map((Announcement announcement) async {
      return DisplayEvent.fromAnnouncement(announcement);
    }));

    UserType? currentUserType = await _userController.getCurrentUserType();
    setState(() {
      _events = events;
      _currentUserType = currentUserType;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return _currentUserType == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'My Announcements',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0.0,
            ),
            drawer: _currentUserType == UserType.professor
                ? ProfessorDrawer(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                    pop: true)
                : TADrawer(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                    pop: true),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                child: _events == null
                    ? const Center(child: CircularProgressIndicator())
                    : _events!.isEmpty
                        ? const Image(
                            image: AssetImage('assets/images/no_data.png'))
                        : EventList(
                            events: _events ?? [],
                            courseName: widget.courseName,
                            getData: _getData)),
          );
  }
}
