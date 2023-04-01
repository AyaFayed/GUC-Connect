import 'package:flutter/material.dart';

class Enroll extends StatefulWidget {
  const Enroll({super.key});

  @override
  State<Enroll> createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Enroll'),
          backgroundColor: const Color.fromARGB(255, 191, 26, 47),
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: SingleChildScrollView());
  }
}
