import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/schedule_event_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_icon_btn.dart';
import 'package:guc_scheduling_app/widgets/date_time_selector.dart';
import 'package:quickalert/quickalert.dart';

class EditEvent extends StatefulWidget {
  final String courseName;
  final String eventId;
  final EventType eventType;

  const EditEvent({
    super.key,
    required this.courseName,
    required this.eventId,
    required this.eventType,
  });

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final ScheduleEventsController _scheduleEventsController =
      ScheduleEventsController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;

  TextEditingController? controllerTitle;
  TextEditingController? controllerDescription;
  TextEditingController? controllerDuration;

  String error = '';
  String fileName = 'No File Selected';
  File? file;
  UploadTask? task;
  DateTime? startDateTime;

  Future<void> completeScheduling() async {
    try {
      String? fileUrl = file != null ? await uploadFile(file, task) : null;
      await _scheduleEventsController.editScheduledEvent(
          widget.eventType,
          widget.eventId,
          controllerTitle!.text,
          controllerDescription!.text,
          fileUrl,
          startDateTime ?? DateTime.now(),
          widget.eventType == EventType.assignments
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
    });
    if (_formKey.currentState!.validate()) {
      if (startDateTime == null) {
        setState(() {
          error = Errors.required;
        });
      } else {
        if (widget.eventType == EventType.assignments) {
          await completeScheduling();
          return;
        }
        int conflicts = await _scheduleEventsController.canScheduleEvent(
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
    DateTime? start;

    switch (widget.eventType) {
      case EventType.announcements:
        break;
      case EventType.assignments:
        Assignment? assignment = await Database.getAssignment(widget.eventId);
        start = assignment?.deadline;
        title = assignment?.title ?? '';
        description = assignment?.description ?? '';
        break;
      case EventType.quizzes:
        Quiz? quiz = await Database.getQuiz(widget.eventId);
        start = quiz?.start;
        title = quiz?.title ?? '';
        description = quiz?.description ?? '';
        duration = quiz!.end.difference(quiz.start).inMinutes.toString();
        break;
      case EventType.compensationLectures:
        CompensationLecture? compensationLecture =
            await Database.getCompensationLecture(widget.eventId);
        start = compensationLecture?.start;
        title = compensationLecture?.title ?? '';
        description = compensationLecture?.description ?? '';
        duration = compensationLecture!.end
            .difference(compensationLecture.start)
            .inMinutes
            .toString();
        break;
      case EventType.compensationTutorials:
        CompensationTutorial? compensationTutorial =
            await Database.getCompensationTutorial(widget.eventId);
        start = compensationTutorial?.start;
        title = compensationTutorial?.title ?? '';
        description = compensationTutorial?.description ?? '';
        duration = compensationTutorial!.end
            .difference(compensationTutorial.start)
            .inMinutes
            .toString();
        break;
    }

    setState(() {
      controllerTitle = TextEditingController(text: title);
      controllerDescription = TextEditingController(text: description);
      controllerDuration = TextEditingController(text: duration);

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
        title: Text(widget.courseName),
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
                          widget.eventType == EventType.assignments
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
                          SmallIconBtn(onPressed: pickFile, text: 'Add file'),
                          const SizedBox(height: 5),
                          Text(
                            fileName,
                            style: TextStyle(
                                fontSize: Sizes.xsmall,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 40.0),
                          LargeBtn(onPressed: editEvent, text: 'Save changes'),
                        ],
                      ),
                    ))),
    );
  }
}
