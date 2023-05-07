import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';

class PostReads {
  final CollectionReference<Map<String, dynamic>> _posts =
      DatabaseReferences.posts;

  Future<Post?> getPost(String postId) async {
    try {
      final postData = await DatabaseReferences.getDocumentData(
          DatabaseReferences.posts, postId);
      if (postData != null) {
        Post post = Post.fromJson(postData);
        return post;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Post>> getAllPosts() async {
    try {
      QuerySnapshot querySnapshot = await _posts.get();

      List<Post> allPosts = querySnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPosts;
    } catch (e) {
      return [];
    }
  }

  Future<List<Post>> getCoursePosts(String courseId) async {
    try {
      QuerySnapshot querySnapshot =
          await _posts.where('courseId', isEqualTo: courseId).get();

      List<Post> posts = querySnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return posts;
    } catch (e) {
      return [];
    }
  }

  Future<List<Post>> getUserPosts(String courseId, String userId) async {
    try {
      QuerySnapshot querySnapshot = await _posts
          .where('authorId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .get();

      List<Post> posts = querySnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return posts;
    } catch (e) {
      return [];
    }
  }
}
