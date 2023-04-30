import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/services/authentication_service.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/set_reminder_text_button.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const SetReminderTextButton(title: 'Set reminder for quizzes'),
              const SizedBox(
                height: 10,
              ),
              const SetReminderTextButton(
                  title: 'Set reminder for assignments'),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                onPressed: () async {
                  await _auth.logout();
                },
                icon: const Icon(Icons.logout),
                label: Text(
                  'Log out',
                  style: TextStyle(fontSize: Sizes.small),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
