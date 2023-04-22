import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/post_card.dart';

class PostList extends StatefulWidget {
  final String courseId;
  final List<Post> posts;
  const PostList({super.key, required this.courseId, required this.posts});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: widget.posts
          .map((post) => PostCard(courseId: widget.courseId, post: post))
          .toList(),
    );
  }
}
