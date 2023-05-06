import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/services/authentication_service.dart';
import 'package:guc_scheduling_app/services/messaging_service.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/set_reminder_text_button.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  final UserController _userController = UserController();
  UserType? _currentUserType;
  final MessagingService _messaging = MessagingService();

  Future<void> _getData() async {
    UserType currentUserType = await _userController.getCurrentUserType();
    setState(() {
      _currentUserType = currentUserType;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: _currentUserType == null
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    if (_currentUserType == UserType.student)
                      Column(
                        children: const [
                          SetReminderTextButton(
                              title: 'Set reminder for quizzes'),
                          SizedBox(
                            height: 10,
                          ),
                          SetReminderTextButton(
                              title: 'Set reminder for assignments'),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    TextButton.icon(
                      onPressed: () async {
                        await _messaging.removeToken();
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
