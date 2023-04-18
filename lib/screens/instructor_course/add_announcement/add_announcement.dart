import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/announcement_controller.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/widgets/buttons/large_btn.dart';
import 'package:guc_scheduling_app/widgets/event_widgets/add_event.dart';

class AddAnnouncement extends StatefulWidget {
  final String courseId;

  const AddAnnouncement({super.key, required this.courseId});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AnnouncementController _announcementsController =
      AnnouncementController();
  final UserController _userController = UserController();

  UserType? _userType;

  String error = '';
  List<String> selectedGroupIds = [];
  List<String> files = [];

  void addAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      await _announcementsController.createAnnouncement(
        widget.courseId,
        controllerTitle.text,
        controllerDescription.text,
        [],
        _userType == UserType.professor ? selectedGroupIds : [],
        _userType == UserType.ta ? selectedGroupIds : [],
      );
    }
  }

  Future<void> _getData() async {
    UserType userType = await _userController.getCurrentUserType();

    setState(() {
      _userType = userType;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: _userType == null
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40.0),
                    AddEvent(
                        controllerTitle: controllerTitle,
                        controllerDescription: controllerDescription,
                        files: files,
                        selectedGroupIds: selectedGroupIds,
                        courseId: widget.courseId),
                    const SizedBox(height: 60.0),
                    LargeBtn(
                        onPressed: addAnnouncement, text: 'Add announcement'),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: AppColors.error, fontSize: 14.0),
                    ),
                  ],
                ),
              ));
  }
}
