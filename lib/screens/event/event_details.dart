import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/widgets/download_file.dart';

class EventDetails extends StatefulWidget {
  final String courseName;
  final String title;
  final String subtitle;
  final String description;
  final String? file;

  const EventDetails({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.courseName,
    required this.file,
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
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
              widget.title,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            widget.file != null
                ? DownloadFile(file: widget.file!)
                : const SizedBox(height: 0.0),
          ],
        ),
      )),
    );
  }
}
