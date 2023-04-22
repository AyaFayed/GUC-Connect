import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/compensation_controller.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/date_time_selector.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_event.dart';
import 'package:quickalert/quickalert.dart';

class ScheduleCompensationLecture extends StatefulWidget {
  final String courseId;
  const ScheduleCompensationLecture({super.key, required this.courseId});

  @override
  State<ScheduleCompensationLecture> createState() =>
      _ScheduleCompensationLectureState();
}

class _ScheduleCompensationLectureState
    extends State<ScheduleCompensationLecture> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerDuration = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CompensationController _compensationController =
      CompensationController();

  String error = '';
  List<String> selectedGroupIds = [];
  File? file;
  UploadTask? task;
  DateTime? startDateTime;

  Future<void> completeScheduling() async {
    try {
      String? fileUrl = await uploadFile(file, task);
      await _compensationController.scheduleCompensationLecture(
          widget.courseId,
          controllerTitle.text,
          controllerDescription.text,
          fileUrl,
          selectedGroupIds,
          startDateTime ?? DateTime.now(),
          startDateTime?.add(
                  Duration(minutes: int.parse(controllerDuration.text))) ??
              DateTime.now());
      controllerDescription.clear();
      controllerDuration.clear();
      controllerTitle.clear();
      setState(() {
        startDateTime = null;
        file = null;
        task = null;
      });
      if (context.mounted) {
        Navigator.pop(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          confirmBtnColor: AppColors.confirm,
          text: Confirmations.scheduleSuccess('lecture'),
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

  Future<void> scheduleCompensationLecture() async {
    setState(() {
      error = '';
    });
    if (_formKey.currentState!.validate()) {
      if (startDateTime == null) {
        setState(() {
          error = Errors.required;
        });
      } else {
        int conflicts =
            await _compensationController.canScheduleCompensationLecture(
                selectedGroupIds,
                startDateTime ?? DateTime.now(),
                startDateTime?.add(Duration(
                        minutes: int.parse(controllerDuration.text))) ??
                    DateTime.now());
        if (context.mounted) {
          if (conflicts > 0) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              text: Confirmations.scheduleWarning('lecture', conflicts),
              confirmBtnText: 'Complete',
              cancelBtnText: 'Cancel',
              onConfirmBtnTap: completeScheduling,
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
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 7.0),
              DateTimeSelector(onConfirm: setDateTime, dateTime: startDateTime),
              error.isNotEmpty
                  ? const SizedBox(
                      height: 5.0,
                    )
                  : const SizedBox(
                      height: 0.0,
                    ),
              Text(
                error,
                style: TextStyle(color: AppColors.error, fontSize: 13.0),
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration:
                    const InputDecoration(labelText: 'Duration in minutes'),
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
              const SizedBox(height: 40.0),
              LargeBtn(
                  onPressed: scheduleCompensationLecture,
                  text: 'Schedule lecture'),
            ],
          ),
        ));
  }
}
