import 'package:guc_scheduling_app/shared/errors.dart';

class Confirmations {
  static String updateSuccess = 'This update was completed successfully.';
  static String creationSuccess(String object) =>
      'The $object was created successfully.';
  static String addSuccess(String object) =>
      'The $object was added successfully.';
  static String scheduleSuccess(String object) =>
      'The $object was scheduled successfully.';
  static String postSuccess(String object) =>
      'The $object was posted successfully.';
  static String deleteSuccess(String object) =>
      'The $object was deleted successfully.';

  static String scheduleWarning(String object, int conflicts) =>
      '${Errors.scheduling(conflicts)} Are you sure you want to complete scheduling the $object?';

  static String updateWarning(int conflicts) =>
      '${Errors.scheduling(conflicts)} Are you sure you want to complete this update?';

  static String deleteWarning(String object) =>
      'Are you sure you want to delete this $object?';
}
