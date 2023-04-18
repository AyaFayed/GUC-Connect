import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/auth_controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await _auth.logout();
      },
      child: const Text('Log out'),
    );
  }
}
