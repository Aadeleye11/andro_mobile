import 'package:flutter/material.dart';
import 'theme_colors.dart';
import 'register_page.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const LandingPage({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  bool get _isDark => themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final bg = _isDark
        ? AndroColors.darkBackground
        : AndroColors.lightBackground;
    final surface = _isDark
        ? AndroColors.darkSurface
        : AndroColors.lightSurface;
    final accent = _isDark ? AndroColors.darkAccent : AndroColors.lightAccent;
    final text = _isDark ? AndroColors.darkText : AndroColors.lightText;
    final sub = _isDark
        ? AndroColors.darkSecondary
        : AndroColors.lightSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Top row: logo + theme toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/constellation.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Andro',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: text,
                        ),
                      ),
                    ],
                  ),

                  // Theme toggle
                  GestureDetector(
                    onTap: onToggleTheme,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: sub.withOpacity(0.3)),
                      ),
                      child: Icon(
                        _isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: sub,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Headline
              Text(
                'Your universe\nof possibilities.',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  color: text,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Explore. Connect. Grow.\nAll in one place.',
                style: TextStyle(fontSize: 15, height: 1.6, color: sub),
              ),

              const SizedBox(height: 48),

              // Create account button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          onToggleTheme: onToggleTheme,
                          themeMode: themeMode,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Create an account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Sign in button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          onToggleTheme: onToggleTheme,
                          themeMode: themeMode,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: text,
                    side: BorderSide(color: sub.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'I already have an account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const Spacer(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
