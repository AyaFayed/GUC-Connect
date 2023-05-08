import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initInfo(onclick) {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        try {
          if (details.payload != null && details.payload!.isNotEmpty) {
            onclick();
          } else {}
        } catch (e) {
          //print(e);
        }
        return;
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(".............onMessage...............");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
              message.notification?.android?.channelId ?? 'courses',
              message.notification?.android?.channelId ?? 'courses',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);

      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: const DarwinNotificationDetails());

      if (message.data['isScheduled'] == 'true') {
        notificationsPlugin.zonedSchedule(
            0,
            message.notification?.title,
            message.notification?.body,
            tz.TZDateTime.from(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(message.data['scheduledTime'])),
              tz.local,
            ),
            platformChannelSpecifics,
            payload: message.data['body'],
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      } else {
        await notificationsPlugin.show(0, message.notification?.title,
            message.notification?.body, platformChannelSpecifics,
            payload: message.data['body']);
      }
    });
  }

  sendLocalNotification(String title, String body) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {},
    );
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body.toString(),
      htmlFormatBigText: true,
      contentTitle: title.toString(),
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notifications', 'notifications',
            importance: Importance.high,
            styleInformation: bigTextStyleInformation,
            priority: Priority.high,
            playSound: true);

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());

    await notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  scheduleLocalNotification(
      String title, String body, DateTime dateTime) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {},
    );
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body.toString(),
      htmlFormatBigText: true,
      contentTitle: title.toString(),
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('reminders', 'reminders',
            importance: Importance.high,
            styleInformation: bigTextStyleInformation,
            priority: Priority.high,
            playSound: true);

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());

    notificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(
          dateTime,
          tz.local,
        ),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
