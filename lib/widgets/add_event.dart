import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/widgets/groups_dropdown.dart';

class AddEvent extends StatefulWidget {
  final String courseId;
  final TextEditingController controllerTitle;
  final TextEditingController controllerDescription;
  final List<String> files;
  final List<String> selectedGroupIds;

  const AddEvent(
      {super.key,
      required this.controllerTitle,
      required this.controllerDescription,
      required this.files,
      required this.selectedGroupIds,
      required this.courseId});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextFormField(
        decoration: const InputDecoration(hintText: 'Title'),
        validator: (val) => val!.isEmpty ? 'Enter a title' : null,
        controller: widget.controllerTitle,
      ),
      const SizedBox(height: 20.0),
      TextFormField(
        decoration: const InputDecoration(hintText: 'Description'),
        validator: (val) => val!.isEmpty ? 'Enter the description' : null,
        controller: widget.controllerDescription,
      ),
      const SizedBox(height: 20.0),
      GroupsDropdown(
          courseId: widget.courseId, selectedGroupIds: widget.selectedGroupIds),
      const SizedBox(height: 20.0),
      ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 173, 41)),
          icon: const Icon(Icons.add),
          label: const Text('Add files'))
    ]);
  }
}
