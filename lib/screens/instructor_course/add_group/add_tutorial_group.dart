import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/group_widgets/add_group.dart';

class AddTutorialGroup extends StatefulWidget {
  final String courseId;
  const AddTutorialGroup({super.key, required this.courseId});

  @override
  State<AddTutorialGroup> createState() => _AddTutorialGroupState();
}

class _AddTutorialGroupState extends State<AddTutorialGroup> {
  @override
  Widget build(BuildContext context) {
    return AddGroup(
        courseId: widget.courseId, groupType: GroupType.tutorialGroup);
  }
}
