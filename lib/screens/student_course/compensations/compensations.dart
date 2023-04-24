import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/student_course/compensations/compensation_lectures.dart';
import 'package:guc_scheduling_app/screens/student_course/compensations/compensation_tutorials.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class Compensations extends StatefulWidget {
  final String courseId;
  final String courseName;

  const Compensations(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<Compensations> createState() => _CompensationsState();
}

class _CompensationsState extends State<Compensations>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Lectures'),
            Tab(text: 'Tutorials'),
          ],
          labelColor: AppColors.selected,
          indicatorColor: AppColors.selected,
        ),
        Expanded(
          child: TabBarView(controller: tabController, children: [
            SingleChildScrollView(
                child: CompensationLectures(
              courseId: widget.courseId,
              courseName: widget.courseName,
            )),
            SingleChildScrollView(
                child: CompensationTutorials(
              courseId: widget.courseId,
              courseName: widget.courseName,
            )),
          ]),
        )
      ],
    );
  }
}
