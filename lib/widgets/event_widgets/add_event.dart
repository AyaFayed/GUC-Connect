import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_btn.dart';
import 'package:guc_scheduling_app/widgets/groups_dropdown.dart';
import 'package:guc_scheduling_app/widgets/tutorials_dropdown.dart';

class AddEvent extends StatefulWidget {
  final String courseId;
  final TextEditingController controllerTitle;
  final TextEditingController controllerDescription;
  final File? file;
  final List<String> selectedGroupIds;

  const AddEvent(
      {super.key,
      required this.controllerTitle,
      required this.controllerDescription,
      required this.file,
      required this.selectedGroupIds,
      required this.courseId});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final UserController _userController = UserController();

  UserType? _userType;

  File? file;

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() {
      file = File(path);
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
  Widget build(BuildContext context) {
    return _userType == null
        ? const CircularProgressIndicator()
        : Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (val) => val!.isEmpty ? Errors.required : null,
              controller: widget.controllerTitle,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 7,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (val) => val!.isEmpty ? Errors.required : null,
              controller: widget.controllerDescription,
            ),
            const SizedBox(height: 20.0),
            _userType == UserType.professor
                ? GroupsDropdown(
                    courseId: widget.courseId,
                    selectedGroupIds: widget.selectedGroupIds)
                : TutorialsDropdown(
                    courseId: widget.courseId,
                    selectedTutorialIds: widget.selectedGroupIds),
            const SizedBox(height: 20.0),
            SmallBtn(onPressed: pickFile, text: 'Add file')
          ]);
  }
}
