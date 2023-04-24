import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/quiz_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_icon_btn.dart';
import 'package:guc_scheduling_app/widgets/date_time_selector.dart';
import 'package:guc_scheduling_app/widgets/download_file.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_event.dart';
import 'package:quickalert/quickalert.dart';

class EditEvent extends StatefulWidget {
  final String courseName;
  final DisplayEvent event;

  const EditEvent({
    super.key,
    required this.courseName,
    required this.event,
  });

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerDuration = TextEditingController();
  final QuizController _quizController = QuizController();
  final UserController _userController = UserController();

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
      // await _quizController
      controllerDescription.clear();
      controllerDuration.clear();
      controllerTitle.clear();
      setState(() {
        startDateTime = null;
        file = [];
        task = null;
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

  Future<void> scheduleQuiz() async {
    setState(() {
      error = '';
    });
    if (_formKey.currentState!.validate()) {
      if (startDateTime == null) {
        setState(() {
          error = Errors.required;
        });
      } else {
        int conflicts = await _quizController.canScheduleQuiz(
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
              text: Confirmations.scheduleWarning('quiz', conflicts),
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

  UserType? _userType;
  String fileName = 'No File Selected';

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() {
      file.clear();
      file.add(File(path));
      fileName = getFileName(path);
    });
  }

  Future<void> _getData() async {
    UserType userType = await _userController.getCurrentUserType();

    setState(() {
      _userType = userType;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
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
                      style: TextStyle(color: AppColors.error, fontSize: 13.0),
                    ),
                    const SizedBox(height: 5.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                          labelText: 'Duration in minutes'),
                      validator: (val) => val!.isEmpty ? Errors.duration : null,
                      controller: controllerDuration,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (val) => val!.isEmpty ? Errors.required : null,
                      controller: controllerTitle,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 7,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (val) => val!.isEmpty ? Errors.required : null,
                      controller: controllerDescription,
                    ),
                    const SizedBox(height: 20.0),
                    SmallIconBtn(onPressed: pickFile, text: 'Add file'),
                    const SizedBox(height: 5),
                    Text(
                      fileName,
                      style: TextStyle(
                          fontSize: Sizes.xsmall, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 40.0),
                    LargeBtn(onPressed: scheduleQuiz, text: 'Schedule quiz'),
                  ],
                ),
              ))),
    );
  }
}
