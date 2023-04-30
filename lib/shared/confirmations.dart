import 'package:guc_scheduling_app/shared/errors.dart';

class Confirmations {
  static String updateSuccess = 'This update was completed successfully.';
  static String loading = 'This may take a couple of seconds';
  static String setReminder = 'Reminder set successfully.';
  static String disableReminder = 'Reminder turned off successfully.';
  static String unenrollWarning =
      'Are you sure you want to unenroll from this course?';
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

  static String clearWarning(String object) =>
      'Are you sure you want to clear all the data related to this $object?';

  static String clearAllWarning =
      'Are you sure you want to clear all the data related to all courses?';

  static String clearSelectedWarning =
      'Are you sure you want to clear all the data related to the selected courses?';
}
