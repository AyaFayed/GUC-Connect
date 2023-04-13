import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/division_controller.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class TutorialsDropdown extends StatefulWidget {
  final String courseId;
  final List<String> selectedTutorialIds;

  const TutorialsDropdown(
      {super.key, required this.courseId, required this.selectedTutorialIds});

  @override
  State<TutorialsDropdown> createState() => _TutorialsDropdownState();
}

class _TutorialsDropdownState extends State<TutorialsDropdown> {
  final DivisionController _divisionController = DivisionController();

  String error = '';

  List<Tutorial>? _myTutorials;

  List<MultiSelectItem<String>> tutorials = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<Tutorial> otherTutorials =
        await _divisionController.getOtherCourseTutorials(widget.courseId);

    List<Tutorial> myTutorials =
        await _divisionController.getMyCourseTutorials(widget.courseId);

    setState(() {
      _myTutorials = myTutorials;

      tutorials = myTutorials
          .map((tutorial) => MultiSelectItem<String>(
                tutorial.id,
                'Tutorial ${tutorial.number.toString()} ${formatLectures(tutorial.lectures)}',
              ))
          .toList();

      tutorials.addAll(otherTutorials
          .map((tutorial) => MultiSelectItem<String>(
                tutorial.id,
                'Tutorial ${tutorial.number.toString()} ${formatLectures(tutorial.lectures)}',
              ))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return _myTutorials == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : MultiSelectDialogField(
            items: tutorials,
            title: const Text('Select tutorials'),
            searchable: true,
            validator: (val) => val == null || val.isEmpty
                ? 'Choose at least one tutorial'
                : null,
            listType: MultiSelectListType.LIST,
            onConfirm: (values) {
              setState(() {
                widget.selectedTutorialIds.clear();
                widget.selectedTutorialIds.addAll(values);
              });
            },
          );
  }
}
