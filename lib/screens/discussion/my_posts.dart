import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/discussion_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/discussion_widgets/post_card.dart';
import 'package:guc_scheduling_app/widgets/drawers/professor_drawer.dart';
import 'package:guc_scheduling_app/widgets/drawers/student_drawer.dart';
import 'package:guc_scheduling_app/widgets/drawers/ta_drawer.dart';

class MyPosts extends StatefulWidget {
  final String courseId;
  final String courseName;
  const MyPosts({super.key, required this.courseId, required this.courseName});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  final DiscussionController _discussionController = DiscussionController();
  final UserController _userController = UserController();

  List<PostCard> _postCards = [];
  List<Post>? _posts;
  UserType? _currentUserType;

  Future<void> _getData() async {
    List<Post> posts = await _discussionController.getMyPosts(widget.courseId);
    UserType? currentUserType = await _userController.getCurrentUserType();

    List<PostCard> postCards = [];

    for (Post post in posts) {
      postCards.add(
          PostCard(courseId: widget.courseId, post: post, getData: _getData));
    }

    setState(() {
      _posts = posts;
      _postCards = postCards;
      _currentUserType = currentUserType;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My posts'),
          elevation: 0.0,
        ),
        drawer: _currentUserType == UserType.student
            ? StudentDrawer(
                courseId: widget.courseId,
                courseName: widget.courseName,
                pop: true)
            : _currentUserType == UserType.professor
                ? ProfessorDrawer(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                    pop: true)
                : TADrawer(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                    pop: true),
        body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: _posts == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                    children: [
                      _postCards.isEmpty
                          ? const Text("You haven't added any posts yet.")
                          : const SizedBox(
                              height: 0.0,
                            ),
                      ..._postCards,
                    ],
                  ))));
  }
}
