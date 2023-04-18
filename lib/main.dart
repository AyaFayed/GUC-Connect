import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/themes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const Wrapper(), title: appName, theme: CustomTheme.lightTheme);
  }
}
