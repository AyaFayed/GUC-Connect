import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/instructor_course/view_my_events/my_announcements.dart';
import 'package:guc_scheduling_app/screens/instructor_course/view_my_events/my_assignments.dart';
import 'package:guc_scheduling_app/screens/instructor_course/view_my_events/my_compensation_lectures.dart';
import 'package:guc_scheduling_app/screens/instructor_course/view_my_events/my_quizzes.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class ProfessorDrawer extends StatefulWidget {
  final String courseId;
  final String courseName;
  final bool pop;
  const ProfessorDrawer(
      {super.key,
      required this.courseId,
      required this.courseName,
      required this.pop});

  @override
  State<ProfessorDrawer> createState() => _ProfessorDrawerState();
}

class _ProfessorDrawerState extends State<ProfessorDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text(
              widget.courseName,
              style: TextStyle(color: AppColors.light, fontSize: Sizes.medium),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.notifications,
            ),
            title: const Text('My announcements'),
            onTap: () {
              Navigator.pop(context);
              if (widget.pop) Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Card(
                      child: MyAnnouncements(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                  )),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.edit_document,
            ),
            title: const Text('Scheduled quizzes'),
            onTap: () {
              Navigator.pop(context);
              if (widget.pop) Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Card(
                      child: MyQuizzes(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                  )),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.assignment,
            ),
            title: const Text('Posted assignments'),
            onTap: () {
              Navigator.pop(context);
              if (widget.pop) Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Card(
                      child: MyAssignments(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                  )),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.schedule,
            ),
            title: const Text('Scheduled compensations'),
            onTap: () {
              Navigator.pop(context);
              if (widget.pop) Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Card(
                      child: MyCompensationLectures(
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                  )),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Unenroll'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
