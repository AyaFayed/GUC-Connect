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

  bool _disableAllButtons = false;

  TextEditingController? controllerName;

  Future<void> onConfirm() async {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Card(child: AdminHome()),
        ));
  }

  Future<void> editCourse() async {
    setState(() {
      _disableAllButtons = true;
    });
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
              onConfirmBtnTap: onConfirm,
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

    setState(() {
      _disableAllButtons = false;
    });
  }

  Future<void> cancel() async {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> delete() async {
    setState(() {
      _disableAllButtons = true;
    });
    if (context.mounted) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: Confirmations.deleteWarning('course'),
        confirmBtnText: 'Delete',
        cancelBtnText: 'Cancel',
        onConfirmBtnTap: () async {
          try {
            Navigator.pop(context);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              confirmBtnColor: AppColors.confirm,
              text: Confirmations.loading,
            );
            await _courseController.deleteCourse(widget.courseId);
            if (context.mounted) {
              Navigator.pop(context);
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                confirmBtnColor: AppColors.confirm,
                onConfirmBtnTap: onConfirm,
                text: Confirmations.deleteSuccess('course'),
              );
            }
          } catch (e) {
            Navigator.pop(context);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              confirmBtnColor: AppColors.confirm,
              text: Errors.backend,
            );
          }
        },
        confirmBtnColor: AppColors.error,
      );
    }
    setState(() {
      _disableAllButtons = false;
    });
  }

  Future<void> clearData() async {
    setState(() {
      _disableAllButtons = true;
    });
    if (context.mounted) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: Confirmations.clearWarning('course'),
        confirmBtnText: 'Clear',
        cancelBtnText: 'Cancel',
        onConfirmBtnTap: () async {
          try {
            Navigator.pop(context);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              confirmBtnColor: AppColors.confirm,
              text: Confirmations.loading,
            );
            await _courseController.clearCourse(widget.courseId);
            if (context.mounted) {
              Navigator.pop(context);
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                confirmBtnColor: AppColors.confirm,
                onConfirmBtnTap: onConfirm,
                text: Confirmations.updateSuccess,
              );
            }
          } catch (e) {
            Navigator.pop(context);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              confirmBtnColor: AppColors.confirm,
              text: Errors.backend,
            );
          }
        },
        confirmBtnColor: AppColors.error,
      );
    }
    setState(() {
      _disableAllButtons = false;
    });
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
        title: Text(
          appName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40.0),
                controllerName == null
                    ? const Center(child: CircularProgressIndicator())
                    : TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Name e.g.(CSEN 702 Microprocessors)',
                            errorMaxLines: 3),
                        validator: (val) =>
                            val!.isEmpty ? Errors.required : null,
                        controller: controllerName,
                      ),
                const SizedBox(height: 60.0),
                LargeBtn(
                    onPressed: _disableAllButtons ? null : editCourse,
                    text: 'Save changes'),
                const SizedBox(height: 20.0),
                LargeBtn(
                  onPressed: _disableAllButtons ? null : delete,
                  text: 'Delete course',
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20.0),
                LargeBtn(
                  onPressed: _disableAllButtons ? null : clearData,
                  text: 'Clear data',
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 20.0),
                LargeBtn(
                  onPressed: _disableAllButtons ? null : cancel,
                  text: 'Cancel',
                  color: AppColors.unselected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
