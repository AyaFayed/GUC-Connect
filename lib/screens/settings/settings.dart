import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/models/user/user_model.dart';
import 'package:guc_scheduling_app/services/authentication_service.dart';
import 'package:guc_scheduling_app/services/messaging_service.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/auth_btn.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  final UserController _userController = UserController();
  UserModel? _currentUser;
  final MessagingService _messaging = MessagingService();

  Future<void> setPostNotifications(bool val) async {
    await _userController.updateAllowPostNotifications(val);
    await _getData();
  }

  Future<void> _getData() async {
    UserModel? currentUser = await _userController.getCurrentUser();
    setState(() {
      _currentUser = currentUser;
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
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: _currentUser == null
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        title: Text(
                          'Receive post notifications',
                          style: TextStyle(fontSize: Sizes.small),
                        ),
                        subtitle: const Text(
                          'When you turn this off, you will not get push notifications when new posts are added to courses you are enrolled in.',
                        ),
                        value: _currentUser?.allowPostNotifications ?? true,
                        onChanged: setPostNotifications),
                    const SizedBox(
                      height: 60,
                    ),
                    AuthBtn(
                        onPressed: () async {
                          await _messaging.removeToken();
                          await _auth.logout();
                        },
                        text: 'Log out')
                  ],
                ),
        ),
      ),
    );
  }
}
