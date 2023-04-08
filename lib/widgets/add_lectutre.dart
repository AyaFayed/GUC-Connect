import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class AddLecture extends StatefulWidget {
  final List<DropdownMenuItem<Day>> daysOfWeek;
  final List<DropdownMenuItem<Slot>> slots;

  const AddLecture({super.key, required this.daysOfWeek, required this.slots});

  @override
  State<AddLecture> createState() => _AddLectureState();
}

class _AddLectureState extends State<AddLecture> {
  Day? lectureDay;
  Slot? lectureSlot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20.0),
        DropdownButtonFormField(
            decoration: const InputDecoration(hintText: 'Lecture Day'),
            validator: (val) => val == null ? 'Choose a lecture day' : null,
            items: widget.daysOfWeek,
            onChanged: (val) => setState(() {
                  lectureDay = val;
                })),
        const SizedBox(height: 20.0),
        DropdownButtonFormField(
            decoration: const InputDecoration(hintText: 'Lecture slot'),
            validator: (val) => val == null ? 'Choose a lecture slot' : null,
            items: widget.slots,
            onChanged: (val) => setState(() {
                  lectureSlot = val;
                })),
      ],
    );
  }
}
