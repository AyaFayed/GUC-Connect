import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/dropdowns/groups_dropdown.dart';
import 'package:guc_scheduling_app/widgets/dropdowns/tutorials_dropdown.dart';
import 'package:path/path.dart';

class AddEvent extends StatefulWidget {
  final String courseId;
  final TextEditingController controllerTitle;
  final TextEditingController controllerDescription;
  final List<File> file;
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

  UserType? _currentUserType;
  String fileName = 'No File Selected';

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() {
      widget.file.clear();
      widget.file.add(File(path));
      fileName = basename(path);
    });
  }

  Future<void> _getData() async {
    UserType? userType = await _userController.getCurrentUserType();

    setState(() {
      _currentUserType = userType;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return _currentUserType == null
        ? const CircularProgressIndicator()
        : Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                errorMaxLines: 3,
              ),
              validator: (val) => val!.isEmpty ? Errors.required : null,
              controller: widget.controllerTitle,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 7,
              decoration: const InputDecoration(
                labelText: 'Description',
                errorMaxLines: 3,
              ),
              controller: widget.controllerDescription,
            ),
            const SizedBox(height: 32.0),
            _currentUserType == UserType.professor
                ? GroupsDropdown(
                    courseId: widget.courseId,
                    selectedGroupIds: widget.selectedGroupIds)
                : TutorialsDropdown(
                    courseId: widget.courseId,
                    selectedTutorialIds: widget.selectedGroupIds),
            const SizedBox(height: 24.0),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: pickFile,
                label: Text(
                  widget.file.isEmpty ? 'Add file' : fileName,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: Sizes.smaller),
                ),
                icon: const Icon(Icons.attach_file),
              ),
            ),
          ]);
  }
}
