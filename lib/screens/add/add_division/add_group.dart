import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/division_controller.dart';
import 'package:guc_scheduling_app/models/divisions/division_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class AddGroup extends StatefulWidget {
  final String courseId;
  const AddGroup({super.key, required this.courseId});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  final controllerGroupNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DivisionController _divisionController = DivisionController();

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

  String error = '';
  Day? lectureDay;
  Slot? lectureSlot;

  @override
  void dispose() {
    controllerGroupNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40.0),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: 'Group Number'),
                validator: (val) =>
                    val!.isEmpty ? 'Enter a valid group number' : null,
                controller: controllerGroupNumber,
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField(
                  decoration: const InputDecoration(hintText: 'Lecture Day'),
                  validator: (val) =>
                      val == null ? 'Choose a lecture day' : null,
                  items: daysOfWeek,
                  onChanged: (val) => setState(() {
                        lectureDay = val;
                      })),
              const SizedBox(height: 20.0),
              DropdownButtonFormField(
                  decoration: const InputDecoration(hintText: 'Lecture slot'),
                  validator: (val) =>
                      val == null ? 'Choose a lecture slot' : null,
                  items: slots,
                  onChanged: (val) => setState(() {
                        lectureSlot = val;
                      })),
              const SizedBox(height: 60.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                    textStyle: const TextStyle(fontSize: 22),
                    backgroundColor: const Color.fromARGB(255, 50, 55, 59)),
                child: const Text(
                  'Add Group',
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _divisionController.createGroup(widget.courseId,
                        int.parse(controllerGroupNumber.text), [
                      Lecture(
                          day: lectureDay ?? Day.saturday,
                          slot: lectureSlot ?? Slot.first)
                    ]);
                  }
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ));
  }
}
