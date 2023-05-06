import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';
import 'package:guc_scheduling_app/models/discussion/post_model.dart';

class PostWrites {
  final CollectionReference<Map<String, dynamic>> _posts =
      DatabaseReferences.posts;

  Future deletePost(String id) async {
    await _posts.doc(id).delete();
  }

  Future deleteAllPosts() async {
    QuerySnapshot querySnapshot = await _posts.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  Future deleteCoursePosts(String courseId) async {
    QuerySnapshot querySnapshot =
        await _posts.where('courseId', isEqualTo: courseId).get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }

  Future addReplyToPost(String postId, Reply reply) async {
    await _posts.doc(postId).update({
      'replies': FieldValue.arrayUnion([reply.toJson()])
    });
  }

  Future updatePostReplies(String postId, List<Reply> replies) async {
    await _posts.doc(postId).update({'replies': replies});
  }
}
