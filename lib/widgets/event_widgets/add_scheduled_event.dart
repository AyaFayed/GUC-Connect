import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/scheduled_event_controller.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/date_time_selector.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_event.dart';
import 'package:quickalert/quickalert.dart';

class AddScheduledEvent extends StatefulWidget {
  final String courseId;
  final String courseName;
  final EventType eventType;

  const AddScheduledEvent(
      {super.key,
      required this.courseId,
      required this.courseName,
      required this.eventType});

  @override
  State<AddScheduledEvent> createState() => _AddScheduledEventState();
}

class _AddScheduledEventState extends State<AddScheduledEvent> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerDuration = TextEditingController();
  final ScheduledEventsController _scheduledEventsController =
      ScheduledEventsController();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  List<String> selectedGroupIds = [];
  List<File> file = [];
  UploadTask? task;
  DateTime? startDateTime;

  Future<void> completeScheduling() async {
    try {
      String? fileUrl =
          file.isNotEmpty ? await uploadFile(file.first, task) : null;
      await _scheduledEventsController.scheduleEvent(
          widget.courseId,
          widget.courseName,
          controllerTitle.text,
          controllerDescription.text,
          fileUrl,
          selectedGroupIds,
          startDateTime ?? DateTime.now(),
          startDateTime?.add(
                  Duration(minutes: int.parse(controllerDuration.text))) ??
              DateTime.now(),
          widget.eventType);
      controllerDescription.clear();
      controllerDuration.clear();
      controllerTitle.clear();
      setState(() {
        startDateTime = null;
        file = [];
        task = null;
      });
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          confirmBtnColor: AppColors.confirm,
          text:
              Confirmations.scheduleSuccess(formatEventType(widget.eventType)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnColor: AppColors.confirm,
          text: Errors.backend,
        );
      }
    }
  }

  Future<void> scheduleEvent() async {
    setState(() {
      error = '';
    });
    if (_formKey.currentState!.validate()) {
      if (startDateTime == null) {
        setState(() {
          error = Errors.required;
        });
      } else {
        int conflicts = await _scheduledEventsController.canScheduleGroups(
            selectedGroupIds,
            startDateTime ?? DateTime.now(),
            startDateTime?.add(
                    Duration(minutes: int.parse(controllerDuration.text))) ??
                DateTime.now(),
            null);
        if (context.mounted) {
          if (conflicts > 0) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              text: Confirmations.scheduleWarning(
                  formatEventType(widget.eventType), conflicts),
              confirmBtnText: 'Complete',
              cancelBtnText: 'Cancel',
              onConfirmBtnTap: () async {
                Navigator.pop(context);
                await completeScheduling();
              },
              confirmBtnColor: AppColors.error,
            );
          } else {
            await completeScheduling();
          }
        }
      }
    } else if (startDateTime == null) {
      setState(() {
        error = Errors.required;
      });
    }
  }

  void setDateTime(dateTime) {
    setState(() {
      startDateTime = dateTime;
    });
  }

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerDescription.dispose();
    controllerDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 7.0),
                  DateTimeSelector(
                      onConfirm: setDateTime, dateTime: startDateTime),
                  if (error.isNotEmpty)
                    const SizedBox(
                      height: 5.0,
                    ),
                  Text(
                    error,
                    style: TextStyle(color: AppColors.error, fontSize: 13.0),
                  ),
                  if (error.isNotEmpty) const SizedBox(height: 5.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                        labelText: 'Duration in minutes',
                        errorMaxLines: 3,
                        suffixText: 'minutes'),
                    validator: (val) => val!.isEmpty ? Errors.duration : null,
                    controller: controllerDuration,
                  ),
                  const SizedBox(height: 20.0),
                  AddEvent(
                      controllerTitle: controllerTitle,
                      controllerDescription: controllerDescription,
                      file: file,
                      selectedGroupIds: selectedGroupIds,
                      courseId: widget.courseId),
                  const SizedBox(height: 24.0),
                  LargeBtn(
                      onPressed: scheduleEvent,
                      text:
                          'Schedule ${widget.eventType == EventType.quiz ? 'quiz' : 'compensation'}'),
                ],
              ),
            )));
  }
}
