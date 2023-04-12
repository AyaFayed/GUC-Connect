import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/quiz_controller.dart';
import 'package:guc_scheduling_app/widgets/add_event.dart';

class ScheduleQuiz extends StatefulWidget {
  final String courseId;
  const ScheduleQuiz({super.key, required this.courseId});

  @override
  State<ScheduleQuiz> createState() => _ScheduleQuizState();
}

class _ScheduleQuizState extends State<ScheduleQuiz> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerDuration = TextEditingController();
  final QuizController _quizController = QuizController();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  List<String> selectedGroupIds = [];
  List<String> files = [];
  DateTime? startDateTime;

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
                        ? 'Select date and time'
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
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration:
                    const InputDecoration(hintText: 'Duration in minutes'),
                validator: (val) =>
                    val!.isEmpty ? 'Enter a valid duration' : null,
                controller: controllerDuration,
              ),
              const SizedBox(height: 20.0),
              AddEvent(
                  controllerTitle: controllerTitle,
                  controllerDescription: controllerDescription,
                  files: files,
                  selectedGroupIds: selectedGroupIds,
                  courseId: widget.courseId),
              const SizedBox(height: 40.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                    textStyle: const TextStyle(fontSize: 22),
                    backgroundColor: const Color.fromARGB(255, 50, 55, 59)),
                child: const Text(
                  'Schedule Quiz',
                ),
                onPressed: () async {
                  setState(() {
                    error = '';
                  });
                  if (_formKey.currentState!.validate()) {
                    if (startDateTime == null) {
                      setState(() {
                        error = 'Select a valid start date and time';
                      });
                    } else {
                      int conflicts = await _quizController.scheduleQuiz(
                          widget.courseId,
                          controllerTitle.text,
                          controllerDescription.text,
                          files,
                          selectedGroupIds,
                          startDateTime ?? DateTime.now(),
                          startDateTime?.add(Duration(
                                  minutes:
                                      int.parse(controllerDuration.text))) ??
                              DateTime.now());

                      if (conflicts > 0) {
                        setState(() {
                          error =
                              '$conflicts student(s) has conflicts with this timing';
                        });
                      }
                    }
                  } else if (startDateTime == null) {
                    setState(() {
                      error = 'Select a valid start date and time';
                    });
                  }
                },
              ),
            ],
          ),
        ));
  }
}
