import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/compensation_controller.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/date_time_selector.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_event.dart';

class ScheduleCompensationTutorial extends StatefulWidget {
  final String courseId;
  const ScheduleCompensationTutorial({super.key, required this.courseId});

  @override
  State<ScheduleCompensationTutorial> createState() =>
      _ScheduleCompensationTutorialState();
}

class _ScheduleCompensationTutorialState
    extends State<ScheduleCompensationTutorial> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerDuration = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CompensationController _compensationController =
      CompensationController();

  String error = '';
  List<String> selectedTutorialIds = [];
  List<String> files = [];
  DateTime? startDateTime;

  void scheduleCompensationTutorial() async {
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
            await _compensationController.scheduleCompensationTutorial(
                widget.courseId,
                controllerTitle.text,
                controllerDescription.text,
                files,
                selectedTutorialIds,
                startDateTime ?? DateTime.now(),
                startDateTime?.add(Duration(
                        minutes: int.parse(controllerDuration.text))) ??
                    DateTime.now());

        if (conflicts > 0) {
          setState(() {
            error = Errors.scheduling(conflicts);
          });
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
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration:
                    const InputDecoration(hintText: 'Duration in minutes'),
                validator: (val) => val!.isEmpty ? Errors.duration : null,
                controller: controllerDuration,
              ),
              const SizedBox(height: 20.0),
              AddEvent(
                  controllerTitle: controllerTitle,
                  controllerDescription: controllerDescription,
                  files: files,
                  selectedGroupIds: selectedTutorialIds,
                  courseId: widget.courseId),
              const SizedBox(height: 60.0),
              LargeBtn(
                  onPressed: scheduleCompensationTutorial,
                  text: 'Schedule tutorial'),
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
