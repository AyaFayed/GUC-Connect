import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class DiscussionController {
  final UserController _user = UserController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Post?> addPost(String content, String? file, String courseId) async {
    final docPost = Database.posts.doc();

    UserModel? currentUser =
        await Database.getUser(_auth.currentUser?.uid ?? '');

    if (currentUser != null) {
      final post = Post(
          id: docPost.id,
          content: content,
          file: file,
          authorId: _auth.currentUser?.uid ?? '',
          authorName: formatName(currentUser.name, currentUser.type),
          replies: [],
          createdAt: DateTime.now());

      final json = post.toJson();

      await docPost.set(json);

      await addPostToCourse(docPost.id, courseId);

      return post;
    }

    return null;
  }

  Future addPostToCourse(String postId, String courseId) async {
    Course? course = await Database.getCourse(courseId);
    if (course != null) {
      List<String> posts = course.posts;
      posts.add(postId);
      await Database.courses.doc(courseId).update({'posts': posts});
    }
  }

  Future<Reply?> addReplyToPost(String content, String postId) async {
    UserModel? currentUser =
        await Database.getUser(_auth.currentUser?.uid ?? '');

    Post? post = await Database.getPost(postId);

    if (currentUser != null && post != null) {
      Reply reply = Reply(
          content: content,
          authorId: _auth.currentUser?.uid ?? '',
          authorName: formatName(currentUser.name, currentUser.type),
          createdAt: DateTime.now());

      List<Reply> replies = post.replies;
      replies.add(reply);
      await Database.posts.doc(postId).update({'replies': replies});

      return reply;
    }

    return null;
  }

  Future deletePost(String postId, String courseId) async {
    Post? post = await Database.getPost(postId);
    Course? course = await Database.getCourse(courseId);

    if (post != null && course != null) {
      if (post.authorId != _auth.currentUser?.uid) {
        UserType userType = await _user.getCurrentUserType();
        if (userType != UserType.professor) return;
      }

      List<String> posts = course.posts;

      posts.remove(postId);

      await Database.courses.doc(courseId).update({'posts': posts});

      await Database.posts.doc(postId).delete();
    }
  }

  Future deleteReply(String postId, Reply reply) async {
    Post? post = await Database.getPost(postId);

    if (post != null) {
      if (reply.authorId != _auth.currentUser?.uid) {
        UserType userType = await _user.getCurrentUserType();
        if (userType != UserType.professor) return;
      }

      List<Reply> replies = post.replies;

      replies.removeWhere((r) =>
          r.authorId == reply.authorId &&
          r.createdAt == reply.createdAt &&
          r.content == reply.content);

      await Database.posts.doc(postId).update({'replies': replies});
    }
  }

  Future<List<Post>> getCoursePosts(String courseId) async {
    Course? course = await Database.getCourse(courseId);

    if (course != null) {
      List<Post> posts = await Database.getPostListFromIds(course.posts);
      posts.sort(((Post a, Post b) => b.createdAt.compareTo(a.createdAt)));
      return posts;
    }

    return [];
  }
}
