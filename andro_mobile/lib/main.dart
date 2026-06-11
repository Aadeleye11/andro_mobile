import 'package:flutter/material.dart';
import 'ui/launch_screen.dart';
import 'ui/on_boarding_wizard_screen.dart';

void main() {
  runApp(const AndroApp());
}

class AndroApp extends StatelessWidget {
  const AndroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ANDRO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        fontFamily: 'SF Pro Display',
      ),
      home: const LaunchScreen(),
      //home: const OnboardingWizardScreen(),
    );
  }
}
