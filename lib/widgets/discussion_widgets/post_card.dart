import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/discussion_controller.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/reply_list.dart';
import 'package:guc_scheduling_app/widgets/download_file.dart';

class PostCard extends StatefulWidget {
  final String courseId;
  final Post post;
  const PostCard({super.key, required this.courseId, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final DiscussionController _discussionController = DiscussionController();

  bool _showDelete = false;
  bool _showReplies = false;

  Future<void> _getData() async {
    bool canDelete = await _discussionController.canDeletePost(widget.post.id);
    setState(() {
      _showDelete = canDelete;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          widget.post.authorName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(widget.post.content),
        const SizedBox(
          height: 10.0,
        ),
        widget.post.file != null
            ? DownloadFile(file: widget.post.file!)
            : const SizedBox(height: 0.0),
        const SizedBox(
          height: 5.0,
        ),
        const Divider(),
        Row(
          children: [
            _showDelete
                ? TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                      color: AppColors.error,
                    ),
                    label: Text(
                      'Delete post',
                      style: TextStyle(color: AppColors.error),
                    ))
                : const SizedBox(height: 0.0),
            TextButton(
                onPressed: () {
                  setState(() {
                    _showReplies = !_showReplies;
                  });
                },
                child: Text(
                  _showReplies ? 'Hide replies' : 'Show replies',
                  style: TextStyle(color: AppColors.dark),
                ))
          ],
        ),
        const Divider(),
        _showReplies
            ? ReplyList(postId: widget.post.id, replies: widget.post.replies)
            : const SizedBox(height: 0.0)
      ]),
    );
  }
}
