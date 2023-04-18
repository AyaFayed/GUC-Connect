import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.primary,
    );
  }
}
