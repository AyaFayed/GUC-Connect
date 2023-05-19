import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/models/group/group_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';

class AddLecture extends StatefulWidget {
  final Lecture lecture;

  const AddLecture({
    super.key,
    required this.lecture,
  });

  @override
  State<AddLecture> createState() => _AddLectureState();
}

class _AddLectureState extends State<AddLecture> {
  Day? lectureDay;
  Slot? lectureSlot;

  List<DropdownMenuItem<Day>> daysOfWeek = Day.values
      .map((day) => DropdownMenuItem<Day>(
            value: day,
            child: Text(day.name),
          ))
      .cast<DropdownMenuItem<Day>>()
      .toList();

  List<DropdownMenuItem<Slot>> slots = Slot.values
      .map((slot) => DropdownMenuItem<Slot>(
            value: slot,
            child: Text(slot.name),
          ))
      .cast<DropdownMenuItem<Slot>>()
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20.0),
        DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Lecture Day',
              errorMaxLines: 3,
            ),
            validator: (val) => val == null ? Errors.required : null,
            items: daysOfWeek,
            onChanged: (val) => setState(() {
                  lectureDay = val;
                  widget.lecture.setDay(val!);
                })),
        const SizedBox(height: 20.0),
        DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Lecture slot',
              errorMaxLines: 3,
            ),
            validator: (val) => val == null ? Errors.required : null,
            items: slots,
            onChanged: (val) => setState(() {
                  lectureSlot = val;
                  widget.lecture.setSlot(val!);
                })),
      ],
    );
  }
}
