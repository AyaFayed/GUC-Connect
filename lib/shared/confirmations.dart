import 'package:guc_scheduling_app/shared/errors.dart';

class Confirmations {
  static String creationSuccess(String object) =>
      'The $object was created successfully.';
  static String addSuccess(String object) =>
      'The $object was added successfully.';
  static String scheduleSuccess(String object) =>
      'The $object was scheduled successfully.';

  static String scheduleWarning(String object, int conflicts) =>
      '${Errors.scheduling(conflicts)} Are you sure you want to complete scheduling the $object?';
}
