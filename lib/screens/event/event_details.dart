import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/buttons/set_reminder_text_button.dart';
import 'package:guc_scheduling_app/widgets/download_file.dart';

class EventDetails extends StatefulWidget {
  final String courseName;
  final DisplayEvent? event;

  const EventDetails({
    super.key,
    required this.courseName,
    required this.event,
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final UserController _userController = UserController();
  UserType? _currentUserType;

  Future<void> _getData() async {
    UserType? currentUserType = await _userController.getCurrentUserType();
    setState(() {
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
    return widget.event == null
        ? Container()
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.courseName),
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
                child: Container(
              alignment: Alignment.topCenter,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40.0),
                  Text(
                    widget.event!.title,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    widget.event!.subtitle,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    widget.event!.description,
                    style: const TextStyle(fontSize: 20),
                  ),
                  if (widget.event!.description.isNotEmpty)
                    const SizedBox(height: 20.0),
                  widget.event!.file != null
                      ? DownloadFile(file: widget.event!.file!)
                      : const SizedBox(height: 0.0),
                  if (widget.event!.file != null)
                    const SizedBox(
                      height: 20,
                    ),
                  if (_currentUserType == UserType.student)
                    SetReminderTextButton(
                      title: 'Set reminder',
                      eventId: widget.event?.id ?? '',
                    ),
                ],
              ),
            )),
          );
  }
}
