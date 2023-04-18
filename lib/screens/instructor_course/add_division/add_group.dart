import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/division_controller.dart';
import 'package:guc_scheduling_app/models/divisions/division_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/widgets/add_lectutre.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';

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

  static Lecture lecture = Lecture(day: Day.monday, slot: Slot.first);
  static List<Lecture> lectures = [lecture];
  static List<AddLecture> addLecture = [
    AddLecture(
      lecture: lecture,
    )
  ];

  String error = '';

  void addGroup() async {
    if (_formKey.currentState!.validate()) {
      await _divisionController.createGroup(
          widget.courseId, int.parse(controllerGroupNumber.text), lectures);
    }
  }

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
                decoration: const InputDecoration(hintText: 'Group number'),
                validator: (val) => val!.isEmpty ? Errors.required : null,
                controller: controllerGroupNumber,
              ),
              const SizedBox(height: 20.0),
              ...addLecture,
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      Lecture lecture =
                          Lecture(day: Day.monday, slot: Slot.first);
                      lectures.add(lecture);
                      addLecture.add(AddLecture(
                        lecture: lecture,
                      ));
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add lecture',
                  )),
              addLecture.length > 1
                  ? ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          lectures.removeLast();
                          addLecture.removeLast();
                        });
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text(
                        'Remove lecture',
                      ))
                  : const SizedBox(height: 0.0),
              const SizedBox(height: 30.0),
              LargeBtn(onPressed: addGroup, text: 'Add group'),
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
