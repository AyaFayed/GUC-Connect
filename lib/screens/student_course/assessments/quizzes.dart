import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/quiz_controller.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/event_list.dart';

class Quizzes extends StatefulWidget {
  final String courseId;
  final String courseName;
  const Quizzes({super.key, required this.courseId, required this.courseName});

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  final QuizController _quizController = QuizController();

  List<DisplayEvent>? _events;

  Future<void> _getData() async {
    List<Quiz> quizzes = await _quizController.getQuizzes(widget.courseId);

    List<DisplayEvent> events = quizzes.map((Quiz quiz) {
      return DisplayEvent(
          id: quiz.id,
          eventType: EventType.quizzes,
          title: quiz.title,
          subtitle: formatDateRange(quiz.start, quiz.end),
          description: quiz.description,
          file: quiz.file);
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
                ? const Text('There are no quizzes.')
                : EventList(
                    events: _events ?? [],
                    courseName: widget.courseName,
                  ));
  }
}
