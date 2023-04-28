import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/compensation_controller.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/widgets/drawers/ta_drawer.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class MyCompensationTutorials extends StatefulWidget {
  final String courseId;
  final String courseName;
  const MyCompensationTutorials(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<MyCompensationTutorials> createState() =>
      _MyCompensationTutorialsState();
}

class _MyCompensationTutorialsState extends State<MyCompensationTutorials> {
  final CompensationController _compensationController =
      CompensationController();

  List<DisplayEvent>? _events;

  Future<void> _getData() async {
    List<CompensationTutorial> compensationTutorials =
        await _compensationController
            .getMyCompensationTutorials(widget.courseId);

    List<DisplayEvent> events =
        compensationTutorials.map((CompensationTutorial compensationTutorial) {
      return DisplayEvent.fromCompensationTutorial(compensationTutorial);
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
      drawer: TADrawer(
          courseId: widget.courseId, courseName: widget.courseName, pop: true),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: _events == null
              ? const Center(child: CircularProgressIndicator())
              : _events!.isEmpty
                  ? const Text("You haven't scheduled any quizzes yet.")
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
