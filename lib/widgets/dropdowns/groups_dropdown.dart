import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/division_controller.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GroupsDropdown extends StatefulWidget {
  final String courseId;
  final List<String> selectedGroupIds;

  const GroupsDropdown(
      {super.key, required this.courseId, required this.selectedGroupIds});

  @override
  State<GroupsDropdown> createState() => _GroupsDropdownState();
}

class _GroupsDropdownState extends State<GroupsDropdown> {
  final DivisionController _divisionController = DivisionController();

  String error = '';

  List<Group>? _myGroups;

  List<MultiSelectItem<String>> groups = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<Group> otherGroups =
        await _divisionController.getOtherCourseGroups(widget.courseId);

    List<Group> myGroups =
        await _divisionController.getMyCourseGroups(widget.courseId);

    setState(() {
      _myGroups = myGroups;

      groups = myGroups
          .map((group) => MultiSelectItem<String>(
                group.id,
                'Group ${group.number.toString()} ${formatLectures(group.lectures)}',
              ))
          .toList();

      groups.addAll(otherGroups
          .map((group) => MultiSelectItem<String>(
                group.id,
                'Group ${group.number.toString()} ${formatLectures(group.lectures)}',
              ))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return _myGroups == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : MultiSelectDialogField(
            items: groups,
            title: const Text('Select groups'),
            searchable: true,
            validator: (val) =>
                val == null || val.isEmpty ? Errors.group : null,
            listType: MultiSelectListType.LIST,
            onConfirm: (values) {
              setState(() {
                widget.selectedGroupIds.clear();
                widget.selectedGroupIds.addAll(values);
              });
            },
          );
  }
}
