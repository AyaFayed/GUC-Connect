import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/screens/admin/admin_home.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:quickalert/quickalert.dart';

class AdminCourse extends StatefulWidget {
  final String courseId;
  final String courseName;
  const AdminCourse(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<AdminCourse> createState() => _AdminCourseState();
}

class _AdminCourseState extends State<AdminCourse> {
  final CourseController _courseController = CourseController();

  final _formKey = GlobalKey<FormState>();

  TextEditingController? controllerName;

  Future<void> editCourse() async {
    if (_formKey.currentState!.validate()) {
      try {
        dynamic result = await _courseController.editCourse(
          widget.courseId,
          controllerName!.text.trim(),
        );
        if (context.mounted) {
          if (result == null) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              confirmBtnColor: AppColors.confirm,
              onConfirmBtnTap: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Card(child: AdminHome()),
                    ));
              },
              text: Confirmations.updateSuccess,
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
  void initState() {
    super.initState();

    setState(() {
      controllerName = TextEditingController(text: widget.courseName);
    });
  }

  @override
  void dispose() {
    controllerName?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40.0),
                controllerName == null
                    ? const CircularProgressIndicator()
                    : TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Name e.g.(CSEN 702 Microprocessors)',
                        ),
                        validator: (val) =>
                            val!.isEmpty ? Errors.required : null,
                        controller: controllerName,
                      ),
                const SizedBox(height: 40.0),
                LargeBtn(onPressed: editCourse, text: 'Save changes'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
