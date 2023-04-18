import "package:flutter/material.dart";
import "package:guc_scheduling_app/controllers/auth_controller.dart";
import "package:guc_scheduling_app/shared/constants.dart";
import "package:guc_scheduling_app/shared/errors.dart";
import "package:guc_scheduling_app/shared/helper.dart";
import "package:guc_scheduling_app/theme/colors.dart";
import "package:guc_scheduling_app/widgets/buttons/auth_btn.dart";

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

  void signup() async {
    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.signup(controllerEmail.text.trim(),
          controllerPassword.text, controllerName.text, _selectedRole == 2);
      if (result != null) {
        setState(() => error = result);
      }
    }
  }

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
                Text(
                  appName,
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 40.0),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (val) => !isValidMail(val!) ? Errors.email : null,
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
                  validator: (val) => val!.isEmpty ? Errors.required : null,
                  controller: controllerName,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (val) => val!.length < 6 ? Errors.password : null,
                  controller: controllerPassword,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: 'Confirm password'),
                  validator: (val) => val != controllerPassword.text
                      ? Errors.confirmPassword
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
                AuthBtn(onPressed: signup, text: 'Sign up'),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style: TextStyle(color: AppColors.error, fontSize: 14.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16)),
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: Text('Log in',
                        style: TextStyle(color: AppColors.primary)))
              ],
            ),
          )),
    );
  }
}
