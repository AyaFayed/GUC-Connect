import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/home/admin_home.dart';
import 'package:guc_scheduling_app/screens/authenticate/authenticate.dart';
import 'package:guc_scheduling_app/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.email == "ayaa_fayed@yahoo.com") {
                  return AdminHome();
                } else {
                  return Home();
                }
              } else {
                return const Authenticate();
              }
            }),
      );
}
