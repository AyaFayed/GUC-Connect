import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:guc_scheduling_app/database/writes/user_writes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final UserWrites _userWrites = UserWrites();

  void requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // print('User granted provisional permission');
    } else {
      // print('User declined permission');
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  Future<void> setToken() async {
    String? token = await getToken();

    if (token != null) {
      await _userWrites.addToken(token);
    }
  }

  Future<void> removeToken() async {
    String? token = await getToken();

    if (token != null) {
      await _userWrites.removeToken(token);
    }
  }

  Future<void> sendPushNotification(
    String token,
    String body,
    String title,
  ) async {
    String key = 'key=${dotenv.env['FCM_KEY']}';
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': key
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": title
            },
            "to": token
          }));
    } catch (e) {
      if (kDebugMode) {
        print("error push notification");
      }
    }
  }
}
