import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/group_controller.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GroupsDropdown extends StatefulWidget {
  final String courseId;
  final List<String> selectedGroupIds;
  final Function? onConfirm;

  const GroupsDropdown(
      {super.key,
      required this.courseId,
      required this.selectedGroupIds,
      this.onConfirm});

  @override
  State<GroupsDropdown> createState() => _GroupsDropdownState();
}

class _GroupsDropdownState extends State<GroupsDropdown> {
  final GroupController _divisionController = GroupController();

  String error = '';

  List<MultiSelectItem<String>> groups = [];

  Future<void> _getData() async {
    List<Group> allGroups =
        await _divisionController.getCourseLectureGroups(widget.courseId);

    allGroups.sort((a, b) => a.number - b.number);

    setState(() {
      groups = allGroups
          .map((group) => MultiSelectItem<String>(
                group.id,
                'Group ${group.number.toString()} ${formatLectures(group.lectureSlots)}',
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
    return MultiSelectDialogField(
      selectedColor: AppColors.selected,
      buttonText: Text(
        'Select groups',
        style: TextStyle(color: Colors.grey[700], fontSize: Sizes.smaller),
      ),
      items: groups,
      title: const Text('Select groups'),
      searchable: true,
      validator: (val) => val == null || val.isEmpty ? Errors.group : null,
      listType: MultiSelectListType.LIST,
      onConfirm: (values) async {
        setState(() {
          widget.selectedGroupIds.clear();
          widget.selectedGroupIds.addAll(values);
        });
        await widget.onConfirm!();
      },
    );
  }
}
