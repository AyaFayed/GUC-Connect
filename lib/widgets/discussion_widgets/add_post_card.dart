import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';

class AddPost extends StatefulWidget {
  final String courseId;
  final List<Post> posts;
  const AddPost({super.key, required this.courseId, required this.posts});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
