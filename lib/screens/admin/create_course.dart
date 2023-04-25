import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:quickalert/quickalert.dart';

class CreateCourse extends StatefulWidget {
  const CreateCourse({super.key});

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  final CourseController _courseController = CourseController();

  final _formKey = GlobalKey<FormState>();

  final controllerName = TextEditingController();

  Future<void> createCourse() async {
    if (_formKey.currentState!.validate()) {
      try {
        dynamic result = await _courseController.createCourse(
          controllerName.text.trim(),
        );
        controllerName.clear();
        if (context.mounted) {
          if (result == null) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              confirmBtnColor: AppColors.confirm,
              text: Confirmations.creationSuccess('course'),
            );
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              confirmBtnColor: AppColors.confirm,
              text: result.toString(),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            confirmBtnColor: AppColors.confirm,
            text: Errors.backend,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    controllerName.dispose();
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
            const SizedBox(height: 40.0),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Name e.g.(CSEN 702 Microprocessors)',
                  labelText: 'Name'),
              validator: (val) => val!.isEmpty ? Errors.required : null,
              controller: controllerName,
            ),
            const SizedBox(height: 40.0),
            LargeBtn(onPressed: createCourse, text: 'Create course'),
          ],
        ),
      ),
    );
  }
}
