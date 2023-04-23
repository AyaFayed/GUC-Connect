import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/discussion_controller.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/add_post_card.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/post_card.dart';

class Discussion extends StatefulWidget {
  final String courseId;
  const Discussion({super.key, required this.courseId});

  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  final DiscussionController _discussionController = DiscussionController();

  List<PostCard> _postCards = [];
  List<Post>? _posts;

  Future<void> _getData() async {
    List<Post> posts =
        await _discussionController.getCoursePosts(widget.courseId);

    List<PostCard> postCards = [];

    for (Post post in posts) {
      postCards.add(
          PostCard(courseId: widget.courseId, post: post, getData: _getData));
    }

    setState(() {
      _posts = posts;
      _postCards = postCards;
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
                  AddPost(courseId: widget.courseId, getData: _getData),
                  const SizedBox(
                    height: 20.0,
                  ),
                  _postCards.isEmpty
                      ? const Text('There are no posts yet.')
                      : const SizedBox(
                          height: 0.0,
                        ),
                  ..._postCards,
                ],
              ));
  }
}
