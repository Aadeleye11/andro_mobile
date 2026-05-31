import 'package:flutter/material.dart';
import 'ui/landing_page.dart';
import 'ui/theme_colors.dart';

void main() {
  runApp(const AndroApp());
}

class AndroApp extends StatefulWidget {
  const AndroApp({super.key});

  @override
  State<AndroApp> createState() => _AndroAppState();
}

class _AndroAppState extends State<AndroApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Andro',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AndroColors.lightBackground,
        colorScheme: const ColorScheme.light(
          primary: AndroColors.lightAccent,
          surface: AndroColors.lightSurface,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AndroColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AndroColors.darkAccent,
          surface: AndroColors.darkSurface,
        ),
      ),
      home: LandingPage(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}
