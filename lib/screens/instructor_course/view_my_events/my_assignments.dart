import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/assignment_controller.dart';
import 'package:guc_scheduling_app/models/events/assignment_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/widgets/drawers/professor_drawer.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class MyAssignments extends StatefulWidget {
  final String courseId;
  final String courseName;
  const MyAssignments(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<MyAssignments> createState() => _MyAssignmentsState();
}

class _MyAssignmentsState extends State<MyAssignments> {
  final AssignmentController _assignmentController = AssignmentController();

  List<DisplayEvent>? _events;

  Future<void> _getData() async {
    List<Assignment> assignments =
        await _assignmentController.getMyAssignments(widget.courseId);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Posted assignments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
      ),
      drawer: ProfessorDrawer(
          courseId: widget.courseId, courseName: widget.courseName, pop: true),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: _events == null
              ? const Center(child: CircularProgressIndicator())
              : _events!.isEmpty
                  ? const Text("You haven't added any assignments yet.")
                  : SingleChildScrollView(
                      child: EventList(
                      events: _events ?? [],
                      courseName: widget.courseName,
                      editable: true,
                      getData: _getData,
                    ))),
    );
  }
}
