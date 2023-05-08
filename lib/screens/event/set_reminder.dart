import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/event_controllers_helper.dart';
import 'package:guc_scheduling_app/shared/confirmations.dart';
import 'package:guc_scheduling_app/shared/errors.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:quickalert/quickalert.dart';

class SetReminder extends StatefulWidget {
  final String title;
  final String eventId;
  const SetReminder({super.key, required this.title, required this.eventId});

  @override
  State<SetReminder> createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  final _formKey = GlobalKey<FormState>();
  final controllerDays = TextEditingController();
  final controllerHours = TextEditingController();
  final EventsControllerHelper _eventsController = EventsControllerHelper();

  bool _isLoading = false;

  Future<void> setReminder() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        await _eventsController.setReminder(widget.eventId,
            int.parse(controllerDays.text), int.parse(controllerHours.text));
        setState(() {
          controllerDays.clear();
          controllerHours.clear();
        });
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnColor: AppColors.confirm,
            text: Confirmations.setReminder,
          );
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

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> cancel() async {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

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
                        suffixText: 'days',
                        label: Text('Days'),
                        border: OutlineInputBorder()),
                    validator: (val) => val!.isEmpty ? Errors.required : null,
                    controller: controllerDays,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                        label: Text('Hours'),
                        suffixText: 'hours',
                        border: OutlineInputBorder()),
                    validator: (val) => val!.isEmpty ? Errors.required : null,
                    controller: controllerHours,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  LargeBtn(
                      onPressed: _isLoading ? null : setReminder,
                      text: 'Set reminder'),
                  const SizedBox(
                    height: 10,
                  ),
                  LargeBtn(
                    onPressed: _isLoading ? null : cancel,
                    text: 'Cancel',
                    color: AppColors.primary,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
