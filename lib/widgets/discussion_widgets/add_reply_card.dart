import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/discussion_controller.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_btn.dart';
import 'package:quickalert/quickalert.dart';

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
  final DiscussionController _discussionController = DiscussionController();

  Future<void> addReply() async {
    if (_formKey.currentState!.validate()) {
      try {
        Reply? reply = await _discussionController.addReplyToPost(
            controllerReply.text, widget.postId);
        if (reply != null) {
          setState(() {
            widget.replies.add(reply);
          });
        }
        controllerReply.clear();
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnColor: AppColors.confirm,
            text: Confirmations.postSuccess('reply'),
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
    controllerReply.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
          SmallBtn(
            onPressed: addReply,
            text: 'Post reply',
          )
        ],
      ),
    );
  }
}
