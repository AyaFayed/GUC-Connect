import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:guc_scheduling_app/screens/authenticate/forgot_password.dart";
import 'package:guc_scheduling_app/services/authentication_service.dart';
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

  Future<void> login() async {
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
                const SizedBox(height: 120.0),
                const Image(
                  image: AssetImage('assets/images/app_name_logo.png'),
                ),
                const SizedBox(height: 40.0),
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
                const SizedBox(height: 24.0),
                Row(children: [
                  const Spacer(),
                  GestureDetector(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: Sizes.xsmall,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgotPassword())),
                  ),
                ]),
                const SizedBox(height: 32.0),
                AuthBtn(onPressed: login, text: 'Log in'),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style:
                      TextStyle(color: AppColors.error, fontSize: Sizes.xsmall),
                ),
                const SizedBox(height: 25.0),
                RichText(
                    text: TextSpan(
                  text: "No account? ",
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.toggleView();
                        },
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                  style: TextStyle(color: Colors.black, fontSize: Sizes.small),
                )),
              ],
            ),
          )),
    ));
  }
}
