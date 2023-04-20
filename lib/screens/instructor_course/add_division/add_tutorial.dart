import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/division_controller.dart';
import 'package:guc_scheduling_app/models/divisions/division_model.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/add_lectutre.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_btn.dart';
import 'package:quickalert/quickalert.dart';

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

  void addTutorial() async {
    if (_formKey.currentState!.validate()) {
      try {
        dynamic result = await _divisionController.createTutorial(
            widget.courseId,
            int.parse(controllerTutorialNumber.text),
            lectures);
        controllerTutorialNumber.clear();
        setState(() {
          lecture = Lecture(day: Day.monday, slot: Slot.first);
          lectures = [lecture];
          addLecture = [
            AddLecture(
              lecture: lecture,
            )
          ];
        });
        if (context.mounted) {
          if (result == null) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              confirmBtnColor: AppColors.confirm,
              text: Confirmations.addSuccess('tutorial'),
            );
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              confirmBtnColor: AppColors.confirm,
              text: result.toString(),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            confirmBtnColor: AppColors.confirm,
            text: Errors.backend,
          );
        }
      }
    }
  }

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
                decoration: const InputDecoration(labelText: 'Tutorial number'),
                validator: (val) => val!.isEmpty ? Errors.required : null,
                controller: controllerTutorialNumber,
              ),
              const SizedBox(height: 20.0),
              ...addLecture,
              const SizedBox(height: 20.0),
              SmallBtn(
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
                  text: 'Add lecture'),
              addLecture.length > 1
                  ? SmallBtn(
                      onPressed: () {
                        setState(() {
                          lectures.removeLast();
                          addLecture.removeLast();
                        });
                      },
                      text: 'Remove lecture',
                      icon: const Icon(Icons.delete_outline),
                    )
                  : const SizedBox(height: 0.0),
              const SizedBox(height: 30.0),
              LargeBtn(onPressed: addTutorial, text: 'Add tutorial'),
            ],
          ),
        ));
  }
}
