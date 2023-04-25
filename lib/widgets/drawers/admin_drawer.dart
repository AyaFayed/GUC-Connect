import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/admin/add_admin.dart';
import 'package:guc_scheduling_app/services/authentication_service.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class AdminDrawer extends StatefulWidget {
  final bool pop;
  const AdminDrawer({super.key, required this.pop});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text(
              'Admin',
              style: TextStyle(color: AppColors.light, fontSize: Sizes.medium),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.admin_panel_settings_outlined,
            ),
            title: const Text('Add admin'),
            onTap: () {
              Navigator.pop(context);
              if (widget.pop) Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Card(child: AddAdmin()),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Log out'),
            onTap: () async {
              await _auth.logout();
            },
          ),
        ],
      ),
    );
  }
}
