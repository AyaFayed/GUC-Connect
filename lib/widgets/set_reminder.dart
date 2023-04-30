import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/buttons/small_btn.dart';

class SetReminder extends StatefulWidget {
  final String title;
  const SetReminder({super.key, required this.title});

  @override
  State<SetReminder> createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  final _formKey = GlobalKey<FormState>();
  final controllerDays = TextEditingController();

  Future<void> setReminder() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Remind me before:',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: Sizes.medium,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                        suffixText: 'days', border: OutlineInputBorder()),
                    validator: (val) => val!.isEmpty ? Errors.required : null,
                    controller: controllerDays,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  LargeBtn(onPressed: setReminder, text: 'Set reminder')
                ]),
          ),
        ),
      ),
    );
  }
}
