import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/quiz_controller.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/date_time_selector.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_event.dart';
import 'package:quickalert/quickalert.dart';

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

  void scheduleQuiz() async {
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
          int conflicts = await _quizController.canScheduleQuiz(
              widget.courseId,
              controllerTitle.text,
              controllerDescription.text,
              files,
              selectedGroupIds,
              startDateTime ?? DateTime.now(),
              startDateTime?.add(
                      Duration(minutes: int.parse(controllerDuration.text))) ??
                  DateTime.now());
          if (context.mounted) {
            if (conflicts > 0) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                text:
                    '${Errors.scheduling(conflicts)} Are you sure you want to complete scheduling the quiz?',
                confirmBtnText: 'Complete',
                cancelBtnText: 'Cancel',
                onConfirmBtnTap: () async {
                  await _quizController.scheduleQuiz(
                      widget.courseId,
                      controllerTitle.text,
                      controllerDescription.text,
                      files,
                      selectedGroupIds,
                      startDateTime ?? DateTime.now(),
                      startDateTime?.add(Duration(
                              minutes: int.parse(controllerDuration.text))) ??
                          DateTime.now());
                  controllerDescription.clear();
                  controllerDuration.clear();
                  controllerTitle.clear();
                  setState(() {
                    startDateTime = null;
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      confirmBtnColor: AppColors.confirm,
                      text: Confirmations.scheduleSuccess('quiz'),
                    );
                  }
                },
                confirmBtnColor: AppColors.error,
              );
            } else {
              controllerDescription.clear();
              controllerDuration.clear();
              controllerTitle.clear();
              setState(() {
                startDateTime = null;
              });
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                confirmBtnColor: AppColors.confirm,
                text: Confirmations.scheduleSuccess('quiz'),
              );
            }
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
                    const InputDecoration(hintText: 'Duration in minutes'),
                validator: (val) => val!.isEmpty ? Errors.duration : null,
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
              LargeBtn(onPressed: scheduleQuiz, text: 'Schedule quiz'),
            ],
          ),
        ));
  }
}
