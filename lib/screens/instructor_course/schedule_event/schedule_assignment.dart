import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/assignment_controller.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/date_time_selector.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_event.dart';
import 'package:quickalert/quickalert.dart';

class ScheduleAssignment extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ScheduleAssignment(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<ScheduleAssignment> createState() => _ScheduleAssignmentState();
}

class _ScheduleAssignmentState extends State<ScheduleAssignment> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AssignmentController _assignmentController = AssignmentController();

  String error = '';
  List<String> selectedGroupIds = [];
  List<File> file = [];
  UploadTask? task;
  DateTime? startDateTime;

  Future<void> scheduleAssignment() async {
    setState(() {
      error = '';
    });
    if (_formKey.currentState!.validate()) {
      if (startDateTime == null) {
        setState(() {
          error = Errors.required;
        });
      } else {
        try {
          String? fileUrl =
              file.isNotEmpty ? await uploadFile(file.first, task) : null;
          await _assignmentController.scheduleAssignment(
            widget.courseId,
            widget.courseName,
            controllerTitle.text,
            controllerDescription.text,
            fileUrl,
            selectedGroupIds,
            startDateTime ?? DateTime.now(),
          );
          controllerTitle.clear();
          controllerDescription.clear();
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
              text: Confirmations.addSuccess('assignment'),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 7.0),
              DateTimeSelector(onConfirm: setDateTime, dateTime: startDateTime),
              if (error.isNotEmpty)
                const SizedBox(
                  height: 5.0,
                ),
              Text(
                error,
                style: TextStyle(color: AppColors.error, fontSize: 13.0),
              ),
              if (error.isNotEmpty) const SizedBox(height: 5.0),
              AddEvent(
                  controllerTitle: controllerTitle,
                  controllerDescription: controllerDescription,
                  file: file,
                  selectedGroupIds: selectedGroupIds,
                  courseId: widget.courseId),
              const SizedBox(height: 24.0),
              LargeBtn(onPressed: scheduleAssignment, text: 'Post assignment'),
            ],
          ),
        ));
  }
}
