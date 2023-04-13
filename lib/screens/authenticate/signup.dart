import "package:flutter/material.dart";
import "package:guc_scheduling_app/controllers/auth_controller.dart";
import "package:guc_scheduling_app/shared/helper.dart";

class Signup extends StatefulWidget {
  final Function toggleView;
  const Signup({super.key, required this.toggleView});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthService _auth = AuthService();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();
  final controllerName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isTa = false;
  bool _isInstructor = false;
  String error = '';

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
    controllerName.dispose();
    super.dispose();
  }

  int _selectedRole = 1;

  List<RadioListTile<int>> _buildRadioList() {
    return [
      RadioListTile(
        title: const Text('Professor'),
        value: 1,
        groupValue: _selectedRole,
        onChanged: (value) {
          setState(() {
            _selectedRole = value!;
          });
        },
      ),
      RadioListTile(
        title: const Text('Teaching assistant'),
        value: 2,
        groupValue: _selectedRole,
        onChanged: (value) {
          setState(() {
            _selectedRole = value!;
          });
        },
      ),
    ];
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
                const SizedBox(height: 80.0),
                const Text(
                  'GUC Notifications',
                  style: TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 40.0),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (val) =>
                      !isValidMail(val!) ? 'Enter a valid email' : null,
                  controller: controllerEmail,
                  onChanged: (value) {
                    if (isInstructor(value)) {
                      setState(() {
                        _isInstructor = true;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Name'),
                  validator: (val) =>
                      val!.isEmpty ? 'Enter a valid name' : null,
                  controller: controllerName,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (val) =>
                      val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  controller: controllerPassword,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: 'Confirm Password'),
                  validator: (val) => val != controllerPassword.text
                      ? 'This password does not match the password you have entered'
                      : null,
                  controller: controllerConfirmPassword,
                ),
                _isInstructor
                    ? Column(
                        children: <Widget>[
                          const SizedBox(height: 20.0),
                          ..._buildRadioList(),
                          const SizedBox(height: 30.0)
                        ],
                      )
                    : const SizedBox(height: 40.0),
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
                        dynamic result = await _auth.signup(
                            controllerEmail.text.trim(),
                            controllerPassword.text,
                            controllerName.text,
                            _selectedRole == 2);
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
