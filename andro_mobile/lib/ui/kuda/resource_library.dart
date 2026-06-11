import 'package:flutter/material.dart';

class ResourceLibraryScreen extends StatelessWidget {
  const ResourceLibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: const Center(child: Text('Resource Library — scaffold for Kuda')),
    );
  }
}
