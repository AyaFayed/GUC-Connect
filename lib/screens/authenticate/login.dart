import "package:flutter/material.dart";
import "package:guc_scheduling_app/controllers/auth_controller.dart";

class Login extends StatefulWidget {
  final toggleView;
  const Login({Key? key, this.toggleView}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = '';

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
                const Text(
                  'GUC Notifications',
                  style: TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 60.0),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  controller: controllerEmail,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                  controller: controllerPassword,
                ),
                const SizedBox(height: 60.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50.0),
                        textStyle: const TextStyle(fontSize: 22),
                        backgroundColor:
                            const Color.fromARGB(255, 191, 26, 47)),
                    child: const Text(
                      'Log In',
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _auth.login(
                            controllerEmail.text.trim(),
                            controllerPassword.text);
                        if (result == null) {
                          setState(() => error = 'Incorrect email or password');
                        }
                      }
                    }),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'Do not have an account?',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 191, 26, 47),
                        textStyle: const TextStyle(fontSize: 16)),
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: const Text('Sign Up'))
              ],
            ),
          )),
    );
  }
}
