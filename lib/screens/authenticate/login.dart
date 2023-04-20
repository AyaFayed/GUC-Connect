import "package:flutter/material.dart";
import "package:guc_scheduling_app/controllers/auth_controller.dart";
import "package:guc_scheduling_app/shared/constants.dart";
import "package:guc_scheduling_app/shared/errors.dart";
import "package:guc_scheduling_app/theme/colors.dart";
import "package:guc_scheduling_app/theme/sizes.dart";
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
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 150.0),
                Text(
                  appName,
                  style: TextStyle(fontSize: Sizes.xlarge),
                ),
                const SizedBox(height: 60.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (val) => val!.isEmpty ? Errors.required : null,
                  controller: controllerEmail,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
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
                  style:
                      TextStyle(color: AppColors.error, fontSize: Sizes.xsmall),
                ),
                const SizedBox(height: 40.0),
                Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: Sizes.small),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        textStyle: TextStyle(
                      fontSize: Sizes.small,
                    )),
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: AppColors.primary),
                    ))
              ],
            ),
          )),
    ));
  }
}
