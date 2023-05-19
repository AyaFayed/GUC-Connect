import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
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
              title: Text(
                widget.courseName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0.0,
            ),
            body: RefreshIndicator(
              onRefresh: _getData,
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 32.0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 30.0),
                        Text(
                          widget.event!.title,
                          style: TextStyle(
                              fontSize: Sizes.large,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          widget.event!.subtitle,
                          style: TextStyle(
                              fontSize: Sizes.small,
                              color: AppColors.unselected),
                        ),
                        if (widget.event!.description.isNotEmpty)
                          Column(children: [
                            const SizedBox(height: 30.0),
                            Text(
                              widget.event!.description,
                              style: TextStyle(fontSize: Sizes.smaller),
                            ),
                          ]),
                        if (widget.event!.file != null)
                          Column(children: [
                            const SizedBox(height: 20.0),
                            DownloadFile(file: widget.event!.file!),
                          ]),
                        const SizedBox(height: 30.0),
                        if (_currentUserType == UserType.student &&
                            widget.event?.eventType != EventType.announcement)
                          SetReminderButton(
                            title: 'Set reminder',
                            eventId: widget.event?.id ?? '',
                          ),
                      ],
                    ),
                  )),
            ));
  }
}
