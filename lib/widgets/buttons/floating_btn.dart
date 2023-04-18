import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class FloatingBtn extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const FloatingBtn({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColors.dark,
      label: Text(text),
    );
  }
}
