import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';

class LargeBtn extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String text;
  final Color? color;
  const LargeBtn(
      {super.key, required this.onPressed, required this.text, this.color});

  @override
  State<LargeBtn> createState() => _LargeBtnState();
}

class _LargeBtnState extends State<LargeBtn> {
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
            minimumSize: const Size.fromHeight(50.0),
            textStyle: TextStyle(fontSize: Sizes.medium),
            backgroundColor: widget.color ?? AppColors.dark),
        onPressed: _isButtonDisabled ? null : onPressed,
        child: Text(
          _isButtonDisabled ? 'Loading...' : widget.text,
        ));
  }
}
