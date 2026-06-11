import 'package:flutter/material.dart';

class QRCheckInScreen extends StatelessWidget {
  const QRCheckInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan to Check In')),
      body: const Center(child: Text('QR Check-in — scaffold for Kuda')),
    );
  }
}
