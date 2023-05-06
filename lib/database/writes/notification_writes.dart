import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/database/database_references.dart';

class NotificationWrites {
  final CollectionReference<Map<String, dynamic>> _notifications =
      DatabaseReferences.notifications;

  Future deleteNotification(String id) async {
    await _notifications.doc(id).delete();
  }

  Future deleteAllNotifications() async {
    QuerySnapshot querySnapshot = await _notifications.get();

    await Future.wait(
        querySnapshot.docs.map((doc) => doc.reference.delete()).toList());
  }
}
