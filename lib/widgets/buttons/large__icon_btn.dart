import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class LargeIconBtn extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final String text;
  final Icon icon;
  final Color? color;
  const LargeIconBtn(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color,
      required this.icon});

  @override
  State<LargeIconBtn> createState() => _LargeIconBtnState();
}

class _LargeIconBtnState extends State<LargeIconBtn> {
  bool _isButtonDisabled = false;

  void onPressed() async {
    setState(() {
      _isButtonDisabled = true;
    });

    await widget.onPressed!();

    if (context.mounted) {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        icon: widget.icon,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50.0),
            textStyle: TextStyle(fontSize: Sizes.medium),
            backgroundColor: widget.color ?? AppColors.primary),
        onPressed:
            _isButtonDisabled || (widget.onPressed == null) ? null : onPressed,
        label: Text(
          _isButtonDisabled ? 'Loading...' : widget.text,
        ));
  }
}
