import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:quickalert/quickalert.dart';

class ClearCourses extends StatefulWidget {
  const ClearCourses({super.key});

  @override
  State<ClearCourses> createState() => _ClearCoursesState();
}

class _ClearCoursesState extends State<ClearCourses> {
  final CourseController _courseController = CourseController();

  final _formKey = GlobalKey<FormState>();

  bool _disableAllButtons = false;

  Future<void> clearAll() async {
    setState(() {
      _disableAllButtons = true;
    });
    if (context.mounted) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: Confirmations.clearAllWarning,
        confirmBtnText: 'Clear all',
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
            await _courseController.clearAllCoursesData();
            if (context.mounted) {
              Navigator.pop(context);
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                confirmBtnColor: AppColors.confirm,
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
              const SizedBox(height: 40.0),
              const SizedBox(height: 40.0),
              LargeBtn(
                  onPressed: _disableAllButtons ? null : clearAll,
                  text: 'Clear selected'),
              const SizedBox(height: 20.0),
              LargeBtn(
                onPressed: _disableAllButtons ? null : clearAll,
                text: 'Clear all',
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
