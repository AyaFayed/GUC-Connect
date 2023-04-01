import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guc_scheduling_app/controllers/course_controller.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

class CreateCourse extends StatefulWidget {
  const CreateCourse({super.key});

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  final CourseController _courseController = CourseController();

  final _formKey = GlobalKey<FormState>();

  // text field state
  String name = '';
  Semester semester = Semester.winter;
  String year = '';
  String error = '';

  var semesterDropdownItems = [
    Semester.winter,
    Semester.spring,
    Semester.summer
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40.0),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Name e.g.(CSEN 702 Microprocessors)'),
              validator: (val) =>
                  val!.isEmpty ? 'Enter a valid course name' : null,
              onChanged: (val) {
                setState(() => name = val);
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Text(
                  'Select semester',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                    width:
                        10), // Add some space between the text and the dropdown
                DropdownButton(
                  value: semester,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: semesterDropdownItems.map((Semester items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (Semester? newValue) {
                    setState(() {
                      semester = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(hintText: 'Year'),
              validator: (val) => val!.isEmpty ? 'Enter a valid year' : null,
              onChanged: (val) {
                setState(() => year = val);
              },
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                    textStyle: const TextStyle(fontSize: 22),
                    backgroundColor: const Color.fromARGB(255, 191, 26, 47)),
                child: const Text(
                  'Create Course',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  setState(() => error = '');
                  if (_formKey.currentState!.validate()) {
                    await _courseController.createCourse(
                        name.trim(), semester, int.parse(year));
                  }
                }),
            const SizedBox(
              height: 12.0,
            ),
            Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
