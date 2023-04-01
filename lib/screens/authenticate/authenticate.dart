import "package:flutter/material.dart";
import "package:guc_scheduling_app/screens/authenticate/login.dart";
import "package:guc_scheduling_app/screens/authenticate/signup.dart";

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showLogIn = true;
  void toggleView() {
    setState(() => showLogIn = !showLogIn);
  }

  @override
  Widget build(BuildContext context) {
    return showLogIn
        ? Login(toggleView: toggleView)
        : Signup(toggleView: toggleView);
  }
}
