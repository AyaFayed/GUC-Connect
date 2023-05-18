import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';

class FloatingBtn extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String text;
  const FloatingBtn({super.key, required this.onPressed, required this.text});

  @override
  State<FloatingBtn> createState() => _FloatingBtnState();
}

class _FloatingBtnState extends State<FloatingBtn> {
  bool _isButtonDisabled = false;

  void onPressed() async {
    setState(() {
      _isButtonDisabled = true;
    });

    await widget.onPressed();

    if (context.mounted) {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _isButtonDisabled ? null : onPressed,
      backgroundColor: AppColors.confirm,
      label: Text(
        _isButtonDisabled ? 'Loading...' : widget.text,
      ),
    );
  }
}
