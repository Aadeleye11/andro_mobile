import 'package:flutter/material.dart';

class OrganiserAttendanceScreen extends StatelessWidget {
  const OrganiserAttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: const Center(child: Text('Organiser Attendance — scaffold for Kuda')),
    );
  }
}
