import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:guc_scheduling_app/firebase_options.dart';
import 'package:guc_scheduling_app/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:timezone/data/latest.dart' as tz;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: ".env");

// Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Wrapper(),
      title: appName,
      theme: CustomTheme.lightTheme,
    );
  }
}
