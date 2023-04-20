class Errors {
  static String email =
      'Enter a valid email address (example@student.guc.edu.eg or example@guc.edu.eg)';
  static String password =
      'Enter a valid password (at least 6 characters long)';
  static String confirmPassword =
      "This password doesn't match the password you entered";
  static String required = 'This field is required';
  static String login = 'Incorrect email or password';
  static String studentEnroll = 'Select a valid group and tutorial';
  static String group = 'Choose at least one group';
  static String tutorial = 'Choose at least one tutorial';
  static String dateTime = 'Select a date and time';
  static String duration = 'Enter a valid duration';
  static String backend = 'Something went wrong';
  static String scheduling(int conflicts) =>
      '$conflicts ${conflicts > 1 ? 'students' : 'student'} has conflicts with this timing.';
}
