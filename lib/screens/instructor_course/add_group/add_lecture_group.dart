import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/group_widgets/add_group.dart';

class AddLectureGroup extends StatefulWidget {
  final String courseId;
  const AddLectureGroup({super.key, required this.courseId});

  @override
  State<AddLectureGroup> createState() => _AddLectureGroupState();
}

class _AddLectureGroupState extends State<AddLectureGroup> {
  @override
  Widget build(BuildContext context) {
    return AddGroup(
        courseId: widget.courseId, groupType: GroupType.lectureGroup);
  }
}
