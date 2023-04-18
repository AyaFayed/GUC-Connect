import 'package:flutter/material.dart';

class FloatingBtn extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const FloatingBtn({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: const Color.fromARGB(255, 50, 55, 59),
      label: Text(text),
    );
  }
}
