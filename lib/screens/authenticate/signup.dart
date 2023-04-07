import "package:flutter/material.dart";
import "package:guc_scheduling_app/controllers/auth_controller.dart";

class Signup extends StatefulWidget {
  final Function toggleView;
  const Signup({super.key, required this.toggleView});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String confirmPassword = '';
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
                const SizedBox(height: 80.0),
                const Text(
                  'GUC Notifications',
                  style: TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 40.0),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Name'),
                  validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                  onChanged: (val) {
                    setState(() => name = val);
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (val) =>
                      val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: 'Confirm Password'),
                  validator: (val) => val != password
                      ? 'This password does not match the password you have entered'
                      : null,
                  onChanged: (val) {
                    setState(() => confirmPassword = val);
                  },
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50.0),
                        textStyle: const TextStyle(fontSize: 22),
                        backgroundColor:
                            const Color.fromARGB(255, 191, 26, 47)),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result =
                            await _auth.signup(email.trim(), password, name);
                        if (result == null) {
                          setState(() => error = 'Enter a valid email');
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
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 16.0),
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
                    child: const Text('Log In'))
              ],
            ),
          )),
    );
  }
}
