import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class LargeBtn extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const LargeBtn({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50.0),
          textStyle: TextStyle(fontSize: Sizes.medium),
          backgroundColor: AppColors.dark),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
