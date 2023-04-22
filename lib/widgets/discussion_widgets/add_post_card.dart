import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/discussion_controller.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_btn.dart';

class AddPost extends StatefulWidget {
  final String courseId;
  final List<Post> posts;
  const AddPost({super.key, required this.courseId, required this.posts});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final controllerPost = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DiscussionController _discussionController = DiscussionController();

  Future<void> addPost() async {}

  @override
  void dispose() {
    controllerPost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 7,
              decoration: const InputDecoration(hintText: 'write a post'),
              validator: (val) => val!.isEmpty ? Errors.required : null,
              controller: controllerPost,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Add file')),
                SmallBtn(
                  onPressed: addPost,
                  text: 'Post',
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
