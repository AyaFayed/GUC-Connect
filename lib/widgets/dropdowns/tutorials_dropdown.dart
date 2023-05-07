import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/group_controller.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
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
  final GroupController _divisionController = GroupController();

  String error = '';

  List<MultiSelectItem<String>> tutorials = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<Group> allTutorials =
        await _divisionController.getCourseTutorialGroups(widget.courseId);

    print(allTutorials);

    setState(() {
      tutorials = allTutorials
          .map((tutorial) => MultiSelectItem<String>(
                tutorial.id,
                'Tutorial ${tutorial.number.toString()} ${formatLectures(tutorial.lectureSlots)}',
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      items: tutorials,
      title: const Text('Select tutorials'),
      searchable: true,
      validator: (val) => val == null || val.isEmpty ? Errors.tutorial : null,
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
