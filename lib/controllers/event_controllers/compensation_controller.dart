import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_scheduling_app/controllers/event_controllers/schedule_event_controller.dart';

class CompensationController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final ScheduleEventsController _scheduleEventsController =
      ScheduleEventsController();
}
