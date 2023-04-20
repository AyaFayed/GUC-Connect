import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/assignment_controller.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/date_time_selector.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_event.dart';

class ScheduleAssignment extends StatefulWidget {
  final String courseId;
  const ScheduleAssignment({super.key, required this.courseId});

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
  List<String> files = [];
  DateTime? startDateTime;

  void scheduleAssignment() async {
    setState(() {
      error = '';
    });
    if (_formKey.currentState!.validate()) {
      if (startDateTime == null) {
        setState(() {
          error = Errors.required;
        });
      } else {
        await _assignmentController.scheduleAssignment(
          widget.courseId,
          controllerTitle.text,
          controllerDescription.text,
          files,
          selectedGroupIds,
          startDateTime ?? DateTime.now(),
        );
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
              AddEvent(
                  controllerTitle: controllerTitle,
                  controllerDescription: controllerDescription,
                  files: files,
                  selectedGroupIds: selectedGroupIds,
                  courseId: widget.courseId),
              const SizedBox(height: 40.0),
              LargeBtn(onPressed: scheduleAssignment, text: 'Add assignment'),
            ],
          ),
        ));
  }
}
