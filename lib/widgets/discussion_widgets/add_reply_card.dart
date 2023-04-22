import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_btn.dart';

class AddReply extends StatefulWidget {
  final String postId;
  final List<Reply> replies;
  const AddReply({super.key, required this.postId, required this.replies});

  @override
  State<AddReply> createState() => _AddReplyState();
}

class _AddReplyState extends State<AddReply> {
  final controllerReply = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> addReply() async {}

  @override
  void dispose() {
    controllerReply.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Reply'),
              validator: (val) => val!.isEmpty ? Errors.required : null,
              controller: controllerReply,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                SmallBtn(
                  onPressed: addReply,
                  text: 'Cancel',
                  color: AppColors.unselected,
                ),
                SmallBtn(
                  onPressed: addReply,
                  text: 'Post reply',
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
