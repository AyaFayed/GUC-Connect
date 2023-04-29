import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_btn.dart';

class SetReminder extends StatefulWidget {
  const SetReminder({super.key});

  @override
  State<SetReminder> createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  final _formKey = GlobalKey<FormState>();
  final controllerDays = TextEditingController();

  bool _hideForm = true;

  Future<void> setReminder() async {}

  @override
  Widget build(BuildContext context) {
    return _hideForm
        ? TextButton.icon(
            onPressed: () {
              setState(() {
                _hideForm = false;
              });
            },
            icon: const Icon(Icons.alarm),
            label: const Text('Set reminder'))
        : Form(
            key: _formKey,
            child: Row(children: <Widget>[
              const Text('Remind me before'),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(labelText: 'days'),
                validator: (val) => val!.isEmpty ? Errors.required : null,
                controller: controllerDays,
              ),
              SmallBtn(onPressed: setReminder, text: 'Set reminder')
            ]),
          );
  }
}
