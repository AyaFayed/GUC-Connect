import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/announcements_controller.dart';
import 'package:guc_scheduling_app/widgets/groups_dropdown.dart';

class AddAnnouncement extends StatefulWidget {
  final String courseId;

  const AddAnnouncement({super.key, required this.courseId});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final controllerTitle = TextEditingController();
  final controllerAnnouncement = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AnnouncementsController _announcementsController =
      AnnouncementsController();

  String error = '';
  List<String> selectedGroupIds = [];

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerAnnouncement.dispose();
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
              GroupsDropdown(
                  courseId: widget.courseId,
                  selectedGroupIds: selectedGroupIds),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Title'),
                validator: (val) => val!.isEmpty ? 'Enter a title' : null,
                controller: controllerTitle,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Announcement'),
                validator: (val) =>
                    val!.isEmpty ? 'Enter the announcement' : null,
                controller: controllerAnnouncement,
              ),
              const SizedBox(height: 60.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                    textStyle: const TextStyle(fontSize: 22),
                    backgroundColor: const Color.fromARGB(255, 50, 55, 59)),
                child: const Text(
                  'Add announcement',
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _announcementsController.createAnnouncement(
                        widget.courseId,
                        controllerTitle.text,
                        controllerAnnouncement.text,
                        [],
                        selectedGroupIds,
                        []);
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
