// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/division_controller.dart';
import 'package:guc_scheduling_app/controllers/enrollment_controller.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/screens/home/home.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class StudentEnroll extends StatefulWidget {
  final String courseId;
  final String courseName;
  final Semester semester;
  final int year;

  const StudentEnroll(
      {super.key,
      required this.courseId,
      required this.courseName,
      required this.semester,
      required this.year});

  @override
  State<StudentEnroll> createState() => _StudentEnrollState();
}

class _StudentEnrollState extends State<StudentEnroll> {
  final DivisionController _divisionController = DivisionController();

  String selectedGroupId = '';
  String selectedTutorialId = '';
  String error = '';

  List<Group>? _groups;
  List<Tutorial>? _tutorials;

  List<DropdownMenuEntry>? groups;
  List<DropdownMenuEntry>? tutorials;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<Group> groupsData =
        await _divisionController.getCourseGroups(widget.courseId);
    List<Tutorial> tutorialsData =
        await _divisionController.getCourseTutorials(widget.courseId);

    setState(() {
      _groups = groupsData;
      _tutorials = tutorialsData;
      groups = _groups!
          .map((group) => DropdownMenuEntry(
              label: group.number.toString(), value: group.id))
          .cast<DropdownMenuEntry>()
          .toList();
      tutorials = _tutorials!
          .map((tutorial) => DropdownMenuEntry(
              label: tutorial.number.toString(), value: tutorial.id))
          .cast<DropdownMenuEntry>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.courseName),
          backgroundColor: const Color.fromARGB(255, 191, 26, 47),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40.0),
              Text(
                widget.courseName,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20.0),
              Text(
                widget.semester.name,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20.0),
              Text(
                widget.year.toString(),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20.0),
              groups == null
                  ? const CircularProgressIndicator()
                  : DropdownMenu(
                      label: const Text('Select group'),
                      dropdownMenuEntries: groups ?? [],
                      onSelected: (value) => selectedGroupId = value as String,
                    ),
              const SizedBox(height: 20.0),
              tutorials == null
                  ? const CircularProgressIndicator()
                  : DropdownMenu(
                      label: const Text('Select tutorial'),
                      dropdownMenuEntries: tutorials ?? [],
                      onSelected: (value) =>
                          selectedTutorialId = value as String),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (selectedGroupId.isEmpty || selectedTutorialId.isEmpty) {
              setState(() {
                error = 'Select a valid group and tutorial';
              });
              return;
            }
            final EnrollmentController enrollmentController =
                EnrollmentController();
            await enrollmentController.studentEnroll(
                widget.courseId, selectedGroupId, selectedTutorialId);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Card(child: Home()),
                ));
          },
          backgroundColor: const Color.fromARGB(255, 50, 55, 59),
          label: const Text('Enroll'),
        ));
  }
}
