import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/add_reply_card.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/reply_card.dart';

class ReplyList extends StatefulWidget {
  final String postId;
  final List<Reply> replies;
  final Future<void> Function() getData;

  const ReplyList(
      {super.key,
      required this.postId,
      required this.replies,
      required this.getData});

  @override
  State<ReplyList> createState() => _ReplyListState();
}

class _ReplyListState extends State<ReplyList> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AddReply(postId: widget.postId, getData: widget.getData),
      const SizedBox(
        height: 5.0,
      ),
      widget.replies.isEmpty
          ? const Text('There are no replies yet.')
          : const SizedBox(height: 0),
      ...widget.replies
          .asMap()
          .entries
          .map((reply) => Column(children: [
                if (reply.key > 0)
                  Divider(
                    color: AppColors.unselected,
                  ),
                ReplyCard(postId: widget.postId, reply: reply.value),
              ]))
          .toList(),
    ]);
  }
}
