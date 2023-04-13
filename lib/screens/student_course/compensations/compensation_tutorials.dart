import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/compensation_controller.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class CompensationTutorials extends StatefulWidget {
  final String courseId;
  final String courseName;
  const CompensationTutorials(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<CompensationTutorials> createState() => _CompensationTutorialsState();
}

class _CompensationTutorialsState extends State<CompensationTutorials> {
  final CompensationController _compensationController =
      CompensationController();

  List<DisplayEvent>? _events;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<CompensationTutorial> compensationTutorials =
        await _compensationController.getCompensationTutorials(widget.courseId);

    List<DisplayEvent> events =
        compensationTutorials.map((CompensationTutorial compensationTutorial) {
      return DisplayEvent(
          title: compensationTutorial.title,
          subtitle: formatDateRange(
              compensationTutorial.start, compensationTutorial.end),
          description: compensationTutorial.description,
          files: compensationTutorial.files);
    }).toList();

    setState(() {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _events == null
        ? const Center(child: CircularProgressIndicator())
        : EventList(
            events: _events ?? [],
            courseName: widget.courseName,
          );
  }
}
