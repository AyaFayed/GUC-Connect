import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/discussion_controller.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/reply_list.dart';
import 'package:guc_scheduling_app/widgets/download_file.dart';
import 'package:quickalert/quickalert.dart';

class PostCard extends StatefulWidget {
  final String courseId;
  final Post post;
  final Future<void> Function() getData;
  const PostCard(
      {super.key,
      required this.courseId,
      required this.post,
      required this.getData});

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
      confirmBtnText: 'Delete',
      cancelBtnText: 'Cancel',
      onConfirmBtnTap: completeDeletingPost,
      confirmBtnColor: AppColors.error,
    );
  }

  void completeDeletingPost() async {
    try {
      await _discussionController.deletePost(widget.post.id);
      await widget.getData();
      if (mounted) {
        Navigator.pop(context);
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
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.post.authorName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: Sizes.small),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(widget.post.content, style: TextStyle(fontSize: Sizes.smaller)),
        const SizedBox(
          height: 10.0,
        ),
        if (widget.post.file != null) DownloadFile(file: widget.post.file!),
        Divider(
          color: AppColors.unselected,
        ),
        Row(
          children: [
            if (_showDelete)
              TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: deletePost,
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                  label: const Text(
                    'Delete post',
                  )),
            const Spacer(),
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
        if (_showReplies)
          ReplyList(
            postId: widget.post.id,
            replies: widget.post.replies,
            getData: widget.getData,
          ),
      ]),
    ));
  }
}
