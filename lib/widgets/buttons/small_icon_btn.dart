import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class SmallIconBtn extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Icon? icon;
  final Color? color;
  const SmallIconBtn(
      {super.key,
      required this.onPressed,
      required this.text,
      this.icon,
      this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: color ?? AppColors.secondary),
        icon: icon ?? const Icon(Icons.add),
        label: Text(text));
  }
}
