import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/announcement_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_event.dart';
import 'package:quickalert/quickalert.dart';

class AddAnnouncement extends StatefulWidget {
  final String courseId;
  final String courseName;

  const AddAnnouncement(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AnnouncementController _announcementsController =
      AnnouncementController();
  final UserController _userController = UserController();

  UserType? _userType;

  List<String> selectedGroupIds = [];
  List<File> file = [];
  UploadTask? task;

  Future<void> addAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? fileUrl =
            file.isNotEmpty ? await uploadFile(file.first, task) : null;
        await _announcementsController.createAnnouncement(
          widget.courseId,
          widget.courseName,
          controllerTitle.text,
          controllerDescription.text,
          fileUrl,
          selectedGroupIds,
        );
        controllerTitle.clear();
        controllerDescription.clear();
        setState(() {
          file = [];
          task = null;
        });
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnColor: AppColors.confirm,
            text: Confirmations.addSuccess('announcement'),
          );
        }
      } catch (e) {
        print(e);
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
  }

  Future<void> _getData() async {
    UserType? userType = await _userController.getCurrentUserType();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: _userType == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40.0),
                    AddEvent(
                        controllerTitle: controllerTitle,
                        controllerDescription: controllerDescription,
                        file: file,
                        selectedGroupIds: selectedGroupIds,
                        courseId: widget.courseId),
                    const SizedBox(height: 40.0),
                    LargeBtn(
                        onPressed: addAnnouncement, text: 'Send announcement'),
                  ],
                ),
              )));
  }
}
