import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';

class PostCard extends StatefulWidget {
  final String courseId;
  final Post post;
  const PostCard({super.key, required this.courseId, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
