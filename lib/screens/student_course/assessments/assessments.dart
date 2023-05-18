import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/student_course/assessments/assignments.dart';
import 'package:guc_scheduling_app/screens/student_course/assessments/quizzes.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class Assessments extends StatefulWidget {
  final String courseId;
  final String courseName;

  const Assessments(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<Assessments> createState() => _AssessmentsState();
}

class _AssessmentsState extends State<Assessments>
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
            Tab(text: 'Quizzes'),
            Tab(text: 'Assignments'),
          ],
          labelColor: AppColors.selected,
          indicatorColor: AppColors.selected,
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              Quizzes(
                courseId: widget.courseId,
                courseName: widget.courseName,
              ),
              Assignments(
                courseId: widget.courseId,
                courseName: widget.courseName,
              ),
            ],
          ),
        )
      ],
    );
  }
}
