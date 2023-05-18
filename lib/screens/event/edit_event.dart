import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/assignment_controller.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/scheduled_event_controller.dart';
import 'package:guc_scheduling_app/database/reads/assignment_reads.dart';
import 'package:guc_scheduling_app/database/reads/scheduled_event_reads.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/scheduled_event.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/date_time_selector.dart';
import 'package:guc_scheduling_app/widgets/download_file.dart';
import 'package:quickalert/quickalert.dart';

class EditEvent extends StatefulWidget {
  final String courseName;
  final String eventId;
  final EventType eventType;
  final Future<void> Function() getData;

  const EditEvent({
    super.key,
    required this.courseName,
    required this.eventId,
    required this.eventType,
    required this.getData,
  });

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final ScheduledEventsController _scheduleEventsController =
      ScheduledEventsController();
  final AssignmentController _assignmentController = AssignmentController();

  final ScheduledEventReads _scheduledEventReads = ScheduledEventReads();
  final AssignmentReads _assignmentReads = AssignmentReads();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  bool _disableAllButtons = false;

  TextEditingController? controllerTitle;
  TextEditingController? controllerDescription;
  TextEditingController? controllerDuration;

  String error = '';
  String fileName = '';
  String? fileUrl;
  File? file;
  UploadTask? task;
  DateTime? startDateTime;

  Future<void> cancel() async {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> delete() async {
    setState(() {
      _disableAllButtons = true;
    });
    if (context.mounted) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: Confirmations.deleteWarning(formatEventType(widget.eventType)),
        confirmBtnText: 'Delete',
        cancelBtnText: 'Cancel',
        onConfirmBtnTap: () async {
          try {
            Navigator.pop(context);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              confirmBtnColor: AppColors.confirm,
              text: Confirmations.loading,
            );
            switch (widget.eventType) {
              case EventType.announcement:
                break;
              case EventType.assignment:
                await _assignmentController.deleteAssignment(
                    widget.courseName, widget.eventId);
                break;
              case EventType.quiz:
              case EventType.compensationLecture:
              case EventType.compensationTutorial:
                await _scheduleEventsController.deleteScheduledEvent(
                    widget.courseName, widget.eventId);
                break;
            }
            if (context.mounted) {
              Navigator.pop(context);
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                confirmBtnColor: AppColors.confirm,
                onConfirmBtnTap: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await widget.getData();
                },
                text: Confirmations.deleteSuccess(
                    formatEventType(widget.eventType)),
              );
            }
          } catch (e) {
            Navigator.pop(context);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              confirmBtnColor: AppColors.confirm,
              text: Errors.backend,
            );
          }
        },
        confirmBtnColor: AppColors.error,
      );
    }
    setState(() {
      _disableAllButtons = false;
    });
  }

  Future<void> completeScheduling() async {
    try {
      if (file != null) {
        fileUrl = await uploadFile(file, task);
      }
      await _scheduleEventsController.editEvent(
          widget.courseName,
          widget.eventType,
          widget.eventId,
          controllerTitle!.text,
          controllerDescription!.text,
          fileUrl,
          startDateTime ?? DateTime.now(),
          widget.eventType == EventType.assignment
              ? null
              : startDateTime?.add(
                      Duration(minutes: int.parse(controllerDuration!.text))) ??
                  DateTime.now());

      setState(() {
        task = null;
      });
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          confirmBtnColor: AppColors.confirm,
          onConfirmBtnTap: () async {
            Navigator.pop(context);
            Navigator.pop(context);
            await widget.getData();
          },
          text: Confirmations.updateSuccess,
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

  Future<void> editEvent() async {
    setState(() {
      error = '';
      _disableAllButtons = true;
    });
    if (_formKey.currentState!.validate()) {
      if (startDateTime == null) {
        setState(() {
          error = Errors.required;
        });
      } else {
        if (widget.eventType == EventType.assignment) {
          await completeScheduling();
          setState(() {
            _disableAllButtons = false;
          });
          return;
        }
        int conflicts = await _scheduleEventsController.canEditScheduledEvent(
            widget.eventType,
            widget.eventId,
            startDateTime ?? DateTime.now(),
            startDateTime?.add(
                    Duration(minutes: int.parse(controllerDuration!.text))) ??
                DateTime.now());
        if (context.mounted) {
          if (conflicts > 0) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              text: Confirmations.updateWarning(conflicts),
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
    setState(() {
      _disableAllButtons = false;
    });
  }

  void setDateTime(dateTime) {
    setState(() {
      startDateTime = dateTime;
    });
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() {
      file = File(path);
      fileName = getFileName(path);
    });
  }

  Future<void> _getData() async {
    String title = '';
    String description = '';
    String duration = '';
    String? fileDownloadLink;
    DateTime? start;

    switch (widget.eventType) {
      case EventType.announcement:
        break;
      case EventType.assignment:
        Assignment? assignment =
            await _assignmentReads.getAssignment(widget.eventId);
        start = assignment?.deadline;
        title = assignment?.title ?? '';
        description = assignment?.description ?? '';
        fileDownloadLink = assignment?.file;
        break;
      case EventType.quiz:
      case EventType.compensationLecture:
      case EventType.compensationTutorial:
        ScheduledEvent? scheduledEvent =
            await _scheduledEventReads.getScheduledEvent(widget.eventId);
        start = scheduledEvent?.start;
        title = scheduledEvent?.title ?? '';
        description = scheduledEvent?.description ?? '';
        duration = scheduledEvent!.end
            .difference(scheduledEvent.start)
            .inMinutes
            .toString();
        fileDownloadLink = scheduledEvent.file;

        break;
    }

    setState(() {
      controllerTitle = TextEditingController(text: title);
      controllerDescription = TextEditingController(text: description);
      controllerDuration = TextEditingController(text: duration);

      fileUrl = fileDownloadLink;

      if (start != null) startDateTime = start;

      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  void dispose() {
    controllerTitle?.dispose();
    controllerDescription?.dispose();
    controllerDuration?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 7.0),
                          DateTimeSelector(
                              onConfirm: setDateTime, dateTime: startDateTime),
                          error.isNotEmpty
                              ? const SizedBox(
                                  height: 5.0,
                                )
                              : const SizedBox(
                                  height: 0.0,
                                ),
                          Text(
                            error,
                            style: TextStyle(
                                color: AppColors.error, fontSize: 13.0),
                          ),
                          const SizedBox(height: 5.0),
                          widget.eventType == EventType.assignment
                              ? const SizedBox(height: 0.0)
                              : TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                      labelText: 'Duration in minutes'),
                                  validator: (val) =>
                                      val!.isEmpty ? Errors.duration : null,
                                  controller: controllerDuration,
                                ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                            validator: (val) =>
                                val!.isEmpty ? Errors.required : null,
                            controller: controllerTitle,
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 7,
                            decoration:
                                const InputDecoration(labelText: 'Description'),
                            validator: (val) =>
                                val!.isEmpty ? Errors.required : null,
                            controller: controllerDescription,
                          ),
                          const SizedBox(height: 20.0),
                          fileUrl != null
                              ? DownloadFile(file: fileUrl!)
                              : const SizedBox(height: 0.0),
                          const SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.topLeft,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: _disableAllButtons ? null : pickFile,
                              label: Text(
                                fileUrl == null ? 'Add file' : 'Change file',
                                style: TextStyle(fontSize: Sizes.small),
                              ),
                              icon: const Icon(Icons.attach_file),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                fileName,
                                style: TextStyle(
                                    fontSize: Sizes.xsmall,
                                    color: AppColors.unselected),
                              )),
                          const SizedBox(height: 20.0),
                          LargeBtn(
                              onPressed: _disableAllButtons ? null : editEvent,
                              text: 'Save changes'),
                          const SizedBox(height: 10.0),
                          LargeBtn(
                            onPressed: _disableAllButtons ? null : delete,
                            text: 'Delete',
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 10.0),
                          LargeBtn(
                            onPressed: _disableAllButtons ? null : cancel,
                            text: 'Cancel',
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ))),
    );
  }
}
