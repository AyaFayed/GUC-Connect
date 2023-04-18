import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/compensation_controller.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class CompensationLectures extends StatefulWidget {
  final String courseId;
  final String courseName;
  const CompensationLectures(
      {super.key, required this.courseId, required this.courseName});

  @override
  State<CompensationLectures> createState() => _CompensationLecturesState();
}

class _CompensationLecturesState extends State<CompensationLectures> {
  final CompensationController _compensationController =
      CompensationController();

  List<DisplayEvent>? _events;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<CompensationLecture> compensationLectures =
        await _compensationController.getCompensationLectures(widget.courseId);

    List<DisplayEvent> events =
        compensationLectures.map((CompensationLecture compensationLecture) {
      return DisplayEvent(
          title: compensationLecture.title,
          subtitle: formatDateRange(
              compensationLecture.start, compensationLecture.end),
          description: compensationLecture.description,
          files: compensationLecture.files);
    }).toList();

    setState(() {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: _events == null
            ? const Center(child: CircularProgressIndicator())
            : EventList(
                events: _events ?? [],
                courseName: widget.courseName,
              ));
  }
}
