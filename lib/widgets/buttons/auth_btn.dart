import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class AuthBtn extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const AuthBtn({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50.0),
            textStyle: TextStyle(fontSize: Sizes.large),
            backgroundColor: AppColors.primary),
        onPressed: onPressed,
        child: Text(
          text,
        ));
  }
}