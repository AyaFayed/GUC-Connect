import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/assignment_controller.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class Assignments extends StatefulWidget {
  final String courseId;
  final String courseName;
  const Assignments(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<Assignments> createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  final AssignmentController _assignmentController = AssignmentController();

  List<DisplayEvent>? _events;

  Future<void> _getData() async {
    List<Assignment> assignments =
        await _assignmentController.getAssignments(widget.courseId);

    List<DisplayEvent> events = assignments.map((Assignment assignment) {
      return DisplayEvent.fromAssignment(assignment);
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
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: _events == null
            ? const Center(child: CircularProgressIndicator())
            : _events!.isEmpty
                ? const Text('There are no assignments.')
                : EventList(
                    events: _events ?? [],
                    courseName: widget.courseName,
                  ));
  }
}
