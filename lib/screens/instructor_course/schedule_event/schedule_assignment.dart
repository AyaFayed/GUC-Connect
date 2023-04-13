import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/assignment_controller.dart';
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
              TextButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  style: TextButton.styleFrom(
                      iconColor: const Color.fromARGB(255, 50, 55, 59)),
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2038), onConfirm: (date) {
                      setState(() {
                        startDateTime = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  label: Text(
                    startDateTime == null
                        ? 'Select due date and time'
                        : startDateTime.toString(),
                    style:
                        const TextStyle(color: Color.fromARGB(255, 50, 55, 59)),
                  )),
              error.isNotEmpty
                  ? const SizedBox(
                      height: 12.0,
                    )
                  : const SizedBox(
                      height: 0.0,
                    ),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 13.0),
              ),
              const SizedBox(height: 12.0),
              AddEvent(
                  controllerTitle: controllerTitle,
                  controllerDescription: controllerDescription,
                  files: files,
                  selectedGroupIds: selectedGroupIds,
                  courseId: widget.courseId),
              const SizedBox(height: 60.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                    textStyle: const TextStyle(fontSize: 22),
                    backgroundColor: const Color.fromARGB(255, 50, 55, 59)),
                child: const Text(
                  'Add Assignment',
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _assignmentController.scheduleAssignment(
                      widget.courseId,
                      controllerTitle.text,
                      controllerDescription.text,
                      files,
                      selectedGroupIds,
                      startDateTime ?? DateTime.now(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ));
  }
}
