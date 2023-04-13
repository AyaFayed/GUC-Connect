import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/quiz_controller.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/events/quiz_model.dart';
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

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    List<Quiz> quizzes = await _quizController.getQuizzes(widget.courseId);

    List<DisplayEvent> events = quizzes.map((Quiz quiz) {
      return DisplayEvent(
          title: quiz.title,
          subtitle: formatDateRange(quiz.start, quiz.end),
          description: quiz.description,
          files: quiz.files);
    }).toList();

    setState(() {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _events == null
        ? const CircularProgressIndicator()
        : EventList(
            events: _events ?? [],
            courseName: widget.courseName,
          );
  }
}
