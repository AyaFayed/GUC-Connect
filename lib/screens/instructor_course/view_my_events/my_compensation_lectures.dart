import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/compensation_controller.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/widgets/drawers/professor_drawer.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class MyCompensationLectures extends StatefulWidget {
  final String courseId;
  final String courseName;
  const MyCompensationLectures(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<MyCompensationLectures> createState() => _MyCompensationLecturesState();
}

class _MyCompensationLecturesState extends State<MyCompensationLectures> {
  final CompensationController _compensationController =
      CompensationController();

  List<DisplayEvent>? _events;

  Future<void> _getData() async {
    List<CompensationLecture> compensationLectures =
        await _compensationController
            .getMyCompensationLectures(widget.courseId);

    List<DisplayEvent> events =
        compensationLectures.map((CompensationLecture compensationLecture) {
      return DisplayEvent(
          title: compensationLecture.title,
          subtitle: formatDateRange(
              compensationLecture.start, compensationLecture.end),
          description: compensationLecture.description,
          file: compensationLecture.file);
    }).toList();

    setState(() {
      _events = events;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled compensations'),
        elevation: 0.0,
      ),
      drawer: ProfessorDrawer(
          courseId: widget.courseId, courseName: widget.courseName, pop: true),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: _events == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: EventList(
                  events: _events ?? [],
                  courseName: widget.courseName,
                ))),
    );
  }
}
