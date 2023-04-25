import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/services/authentication_service.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:quickalert/quickalert.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  Future<void> addAdmin() async {
    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.addAdmin(
          controllerEmail.text.trim(), controllerPassword.text);
      if (context.mounted) {
        if (result != null) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            confirmBtnColor: AppColors.confirm,
            text: result,
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnColor: AppColors.confirm,
            text: Confirmations.addSuccess('admin'),
          );

          setState(() {
            controllerEmail.clear();
            controllerPassword.clear();
            controllerConfirmPassword.clear();
          });
        }
      }
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? Errors.required : null,
                controller: controllerEmail,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (val) => val!.length < 6 ? Errors.password : null,
                controller: controllerPassword,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm password'),
                validator: (val) => val != controllerPassword.text
                    ? Errors.confirmPassword
                    : null,
                controller: controllerConfirmPassword,
              ),
              const SizedBox(height: 60.0),
              LargeBtn(onPressed: addAdmin, text: 'Add admin'),
            ],
          ),
        ));
  }
}
