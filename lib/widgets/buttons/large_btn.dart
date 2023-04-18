import 'package:flutter/material.dart';

class LargeBtn extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const LargeBtn({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50.0),
          textStyle: const TextStyle(fontSize: 22),
          backgroundColor: const Color.fromARGB(255, 50, 55, 59)),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
