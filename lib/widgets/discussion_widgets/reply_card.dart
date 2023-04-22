import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';

class ReplyCard extends StatefulWidget {
  final String postId;
  final Reply reply;
  const ReplyCard({super.key, required this.postId, required this.reply});

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
