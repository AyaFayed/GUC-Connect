import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/division_controller.dart';
import 'package:guc_scheduling_app/models/divisions/division_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/widgets/add_lectutre.dart';

class AddTutorial extends StatefulWidget {
  final String courseId;
  const AddTutorial({super.key, required this.courseId});

  @override
  State<AddTutorial> createState() => _AddTutorialState();
}

class _AddTutorialState extends State<AddTutorial> {
  final controllerTutorialNumber = TextEditingController();
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

  @override
  void dispose() {
    controllerTutorialNumber.dispose();
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
                decoration: const InputDecoration(hintText: 'Tutorial Number'),
                validator: (val) =>
                    val!.isEmpty ? 'Enter a valid tutorial number' : null,
                controller: controllerTutorialNumber,
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
                    'Add Lecture',
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
                        'Remove Lecture',
                      ))
                  : const SizedBox(height: 0.0),
              const SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                    textStyle: const TextStyle(fontSize: 22),
                    backgroundColor: const Color.fromARGB(255, 50, 55, 59)),
                child: const Text(
                  'Add tutorial',
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _divisionController.createTutorial(widget.courseId,
                        int.parse(controllerTutorialNumber.text), lectures);
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
