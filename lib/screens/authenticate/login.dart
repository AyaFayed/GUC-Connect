import "package:flutter/material.dart";
import "package:guc_scheduling_app/controllers/auth_controller.dart";
import "package:guc_scheduling_app/shared/constants.dart";
import "package:guc_scheduling_app/shared/errors.dart";
import "package:guc_scheduling_app/widgets/buttons/auth_btn.dart";

class Login extends StatefulWidget {
  final Function toggleView;
  const Login({super.key, required this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = '';

  void login() async {
    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.login(
          controllerEmail.text.trim(), controllerPassword.text);
      if (result == null) {
        setState(() => error = Errors.login);
      }
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 150.0),
                Text(
                  appName,
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 60.0),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? Errors.required : null,
                  controller: controllerEmail,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (val) => val!.isEmpty ? Errors.required : null,
                  controller: controllerPassword,
                ),
                const SizedBox(height: 60.0),
                AuthBtn(onPressed: login, text: 'Log in'),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                      fontSize: 16,
                    )),
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Color.fromARGB(255, 191, 26, 47)),
                    ))
              ],
            ),
          )),
    );
  }
}
