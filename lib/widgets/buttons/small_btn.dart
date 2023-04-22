import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class SmallBtn extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String text;
  final Color? color;
  const SmallBtn(
      {super.key, required this.onPressed, required this.text, this.color});

  @override
  State<SmallBtn> createState() => _SmallBtnState();
}

class _SmallBtnState extends State<SmallBtn> {
  bool _isButtonDisabled = false;

  void onPressed() async {
    setState(() {
      _isButtonDisabled = true;
    });

    await widget.onPressed();

    setState(() {
      _isButtonDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: widget.color ?? AppColors.secondary),
        onPressed: _isButtonDisabled ? null : onPressed,
        child: Text(
          _isButtonDisabled ? 'Loading...' : widget.text,
        ));
  }
}
