import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/discussion_controller.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/add_post_card.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/post_list.dart';

class Discussion extends StatefulWidget {
  final String courseId;
  const Discussion({super.key, required this.courseId});

  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  final DiscussionController _discussionController = DiscussionController();

  List<Post>? _posts;

  Future<void> _getData() async {
    List<Post> posts =
        await _discussionController.getCoursePosts(widget.courseId);
    setState(() {
      _posts = posts;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: _posts == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  AddPost(courseId: widget.courseId, posts: _posts ?? []),
                  const SizedBox(
                    height: 20.0,
                  ),
                  PostList(courseId: widget.courseId, posts: _posts ?? []),
                ],
              ));
  }
}
