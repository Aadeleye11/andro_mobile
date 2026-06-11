import 'package:flutter/material.dart';

class CampusMapScreen extends StatelessWidget {
  const CampusMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Map')),
      body: const Center(child: Text('Campus Map — scaffold for Kuda')),
    );
  }
}
