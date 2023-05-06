import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/notification_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/database/reads/course_reads.dart';
import 'package:guc_scheduling_app/database/reads/post_reads.dart';
import 'package:guc_scheduling_app/database/reads/user_reads.dart';
import 'package:guc_scheduling_app/database/writes/post_writes.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class DiscussionController {
  final UserController _user = UserController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationController _notificationController =
      NotificationController();
  final CourseReads _courseReads = CourseReads();
  final UserReads _userReads = UserReads();
  final PostReads _postReads = PostReads();
  final PostWrites _postWrites = PostWrites();

  Future<Post?> addPost(String content, String? file, String courseId) async {
    final docPost = DatabaseReferences.posts.doc();

    UserModel? currentUser = await _user.getCurrentUser();

    if (currentUser != null) {
      final post = Post(
          id: docPost.id,
          courseId: courseId,
          content: content,
          file: file,
          authorId: currentUser.id,
          authorName: formatName(currentUser.name, currentUser.type),
          replies: [],
          createdAt: DateTime.now());

      final json = post.toJson();

      await docPost.set(json);

      await notifyUsersAboutPost(docPost.id, content, courseId);

      return post;
    }

    return null;
  }

  Future notifyUsersAboutPost(
      String postId, String content, String courseId) async {
    Course? course = await _courseReads.getCourse(courseId);

    if (course != null) {
      String body = 'New post : $content';
      List<UserModel> users =
          await _userReads.getAllUserIdsEnrolledInACourse(courseId);

      users.removeWhere((user) => user.allowPostNotifications == false);

      List<String> userIds = users.map((user) => user.id).toList();

      await _user.notifyUsers(userIds, course.name, body);

      await _notificationController.createNotification(userIds, course.name,
          course.name, body, postId, NotificationType.post);
    }
  }

  Future<Reply?> addReplyToPost(String content, String postId) async {
    UserModel? currentUser = await _user.getCurrentUser();

    Post? post = await _postReads.getPost(postId);

    if (currentUser != null && post != null) {
      Reply reply = Reply(
          content: content,
          authorId: currentUser.id,
          authorName: formatName(currentUser.name, currentUser.type),
          createdAt: DateTime.now());

      await _postWrites.addReplyToPost(postId, reply);

      await _user.notifyUser(
          post.authorId, '${currentUser.name} replied to your post', content);

      await _notificationController.createNotification(
          [post.authorId],
          null,
          '${currentUser.name} replied to your post',
          post.content,
          postId,
          NotificationType.reply);

      return reply;
    }

    return null;
  }

  Future deletePost(String postId) async {
    await _postWrites.deletePost(postId);
  }

  Future<bool> canDeletePost(String postId) async {
    Post? post = await _postReads.getPost(postId);

    if (post != null) {
      if (post.authorId != _auth.currentUser?.uid) {
        UserType userType = await _user.getCurrentUserType();
        if (userType != UserType.professor) return false;
      }
      return true;
    }

    return false;
  }

  Future deleteReply(String postId, Reply reply) async {
    Post? post = await _postReads.getPost(postId);

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

      await _postWrites.updatePostReplies(postId, replies);
    }
  }

  Future<List<Post>> getCoursePosts(String courseId) async {
    return await _postReads.getCoursePosts(courseId);
  }

  Future<List<Post>> getMyPosts(String courseId) async {
    if (_auth.currentUser == null) return [];
    return await _postReads.getUserPosts(
        courseId, _auth.currentUser?.uid ?? '');
  }
}
