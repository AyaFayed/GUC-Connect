import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/discussion_controller.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_btn.dart';
import 'package:quickalert/quickalert.dart';

class AddPost extends StatefulWidget {
  final String courseId;
  final Future<void> Function() getData;

  const AddPost({super.key, required this.courseId, required this.getData});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final controllerPost = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DiscussionController _discussionController = DiscussionController();

  File? file;
  UploadTask? task;
  String fileName = 'Add file';

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() {
      file = File(path);
      fileName = getFileName(path);
    });
  }

  Future<void> addPost() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? fileUrl = await uploadFile(file, task);
        await _discussionController.addPost(
            controllerPost.text, fileUrl, widget.courseId);
        await widget.getData();
        controllerPost.clear();
        setState(() {
          file = null;
          task = null;
          fileName = 'Add file';
        });
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnColor: AppColors.confirm,
            text: Confirmations.addSuccess('post'),
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
  }

  @override
  void dispose() {
    controllerPost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText: 'write a post',
                  errorMaxLines: 3,
                ),
                validator: (val) => val!.isEmpty ? Errors.required : null,
                controller: controllerPost,
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  SizedBox(
                    width: 220,
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: pickFile,
                        icon: const Icon(Icons.attach_file),
                        label: Text(fileName)),
                  ),
                  const Spacer(),
                  SmallBtn(
                    onPressed: addPost,
                    text: 'Post',
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
