import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/notification_controller.dart';
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
  final NotificationController _notificationController =
      NotificationController();

  Future<Post?> addPost(String content, String? file, String courseId) async {
    final docPost = Database.posts.doc();

    UserModel? currentUser =
        await Database.getUser(_auth.currentUser?.uid ?? '');

    if (currentUser != null) {
      final post = Post(
          id: docPost.id,
          courseId: courseId,
          content: content,
          file: file,
          authorId: _auth.currentUser?.uid ?? '',
          authorName: formatName(currentUser.name, currentUser.type),
          replies: [],
          createdAt: DateTime.now());

      final json = post.toJson();

      await docPost.set(json);

      await addPostToCourse(docPost.id, courseId);

      await notifyUsersAboutPost(docPost.id, content, courseId);

      return post;
    }

    return null;
  }

  Future addPostToCourse(String postId, String courseId) async {
    await Database.courses.doc(courseId).update({
      'posts': FieldValue.arrayUnion([postId])
    });
  }

  Future notifyUsersAboutPost(
      String postId, String content, String courseId) async {
    Course? course = await Database.getCourse(courseId);
    if (course != null) {
      String body = 'New post : $content';
      List<String> userIds = [];
      userIds.addAll(course.professors);
      userIds.addAll(course.tas);
      userIds.addAll(await Database.getDivisionsStudentIds(
          course.groups, DivisionType.groups));

      await _user.notifyUsers(userIds, course.name, body);

      await _notificationController.createNotification(userIds, course.name,
          course.name, body, postId, NotificationType.post);
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

      await Database.posts.doc(postId).update({
        'replies': FieldValue.arrayUnion([reply.toJson()])
      });

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

  Future<bool> canDeletePost(String postId) async {
    Post? post = await Database.getPost(postId);

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
      for (Post post in posts) {
        post.replies
            .sort(((Reply a, Reply b) => a.createdAt.compareTo(b.createdAt)));
      }
      return posts;
    }

    return [];
  }
}
