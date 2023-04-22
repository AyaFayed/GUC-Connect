import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
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
    return ListView(
      shrinkWrap: true,
      children: widget.replies
          .map((reply) => ReplyCard(postId: widget.postId, reply: reply))
          .toList(),
    );
  }
}
