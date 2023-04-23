import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/add_reply_card.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/reply_card.dart';

class ReplyList extends StatefulWidget {
  final String postId;
  final List<Reply> replies;
  const ReplyList({super.key, required this.postId, required this.replies});

  @override
  State<ReplyList> createState() => _ReplyListState();
}

class _ReplyListState extends State<ReplyList> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AddReply(postId: widget.postId, replies: widget.replies),
      const SizedBox(
        height: 15.0,
      ),
      ListView(
        shrinkWrap: true,
        children: widget.replies
            .map((reply) => ReplyCard(postId: widget.postId, reply: reply))
            .toList(),
      ),
    ]);
  }
}
