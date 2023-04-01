import 'package:flutter/material.dart';
import 'package:guc_scheduling_app/screens/Course/my_courses.dart';
import '../../controllers/auth_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MyCourses(),
  ];

  Future<void> _onItemTapped(int index) async {
    if (index == 1) {
      await _auth.logout();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GUC Notifications'),
        backgroundColor: const Color.fromARGB(255, 191, 26, 47),
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Log out',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (val) async {
          await _onItemTapped(val);
        },
      ),
    );
  }
}
