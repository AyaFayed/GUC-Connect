import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class ClearCourses extends StatefulWidget {
  const ClearCourses({super.key});

  @override
  State<ClearCourses> createState() => _ClearCoursesState();
}

class _ClearCoursesState extends State<ClearCourses> {
  final CourseController _courseController = CourseController();

  bool _disableAllButtons = false;

  List<Course>? _courses;

  List<MultiSelectItem<String>> courses = [];

  List<String> selectedCourses = [];

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

  Future<void> clearSelected() async {
    setState(() {
      _disableAllButtons = true;
    });
    if (context.mounted) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: Confirmations.clearSelectedWarning,
        confirmBtnText: 'Clear selected',
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
            await _courseController.clearCourseList(selectedCourses);
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

  Future<void> _getData() async {
    List<Course> coursesData = await _courseController.getAllCourses();

    setState(() {
      _courses = coursesData;
      courses = coursesData
          .map((course) => MultiSelectItem<String>(
                course.id,
                course.name,
              ))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        child: _courses == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  const SizedBox(height: 40.0),
                  MultiSelectDialogField(
                    selectedColor: AppColors.selected,
                    buttonText: Text(
                      'Select courses',
                      style: TextStyle(
                          color: Colors.grey[700], fontSize: Sizes.smaller),
                    ),
                    items: courses,
                    title: const Text('Select courses'),
                    searchable: true,
                    listType: MultiSelectListType.LIST,
                    onConfirm: (values) {
                      setState(() {
                        selectedCourses.clear();
                        selectedCourses.addAll(values);
                      });
                    },
                  ),
                  const SizedBox(height: 60.0),
                  LargeBtn(
                      onPressed: _disableAllButtons ? null : clearSelected,
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
    );
  }
}
