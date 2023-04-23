import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/discussion_controller.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/reply_list.dart';
import 'package:guc_scheduling_app/widgets/download_file.dart';
import 'package:quickalert/quickalert.dart';

class PostCard extends StatefulWidget {
  final String courseId;
  final Post post;
  final List<Post> posts;
  const PostCard(
      {super.key,
      required this.courseId,
      required this.post,
      required this.posts});

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

  void deletePost() async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: Confirmations.deleteWarning('post'),
      confirmBtnText: 'Complete',
      cancelBtnText: 'Cancel',
      onConfirmBtnTap: completeDeletingPost,
      confirmBtnColor: AppColors.error,
    );
  }

  void completeDeletingPost() async {
    try {
      await _discussionController.deletePost(widget.post.id, widget.courseId);
      setState(() {
        widget.posts.removeWhere((p) =>
            p.authorId == widget.post.authorId &&
            p.createdAt == widget.post.createdAt &&
            p.content == widget.post.content);
      });
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          confirmBtnColor: AppColors.confirm,
          text: Confirmations.deleteSuccess('post'),
        );
      }
    } catch (e) {
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnColor: AppColors.confirm,
          text: Errors.backend,
        );
      }
    }
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
                    onPressed: deletePost,
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
