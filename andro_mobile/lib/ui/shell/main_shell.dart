import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_colors.dart';
import '../home/home_feed_page.dart';
import '../explore/explore_page.dart';
import '../notifications/notifications_page.dart';

class MainShell extends StatefulWidget {
  final Map<String, String> currentUser;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const MainShell({
    super.key,
    required this.currentUser,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _unreadNotifications = 2;

  bool get _isDark => widget.themeMode == ThemeMode.dark;

  void _onTabTapped(int pageIndex) {
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = pageIndex);
  }

  void _onNotifTapped() {
    if (_unreadNotifications > 0) {
      setState(() => _unreadNotifications = 0);
    }
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = 2); // Notifications is page index 2
  }

  void _onProfileTapped() {
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = 3); // Profile is page index 3
  }

  @override
  Widget build(BuildContext context) {
    final bg     = _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
    final navBg  = _isDark ? AndroColors.darkNavBg      : AndroColors.lightNavBg;
    final amber  = _isDark ? AndroColors.darkAmber       : AndroColors.lightAmber;
    final grey   = _isDark ? AndroColors.darkSecondary   : AndroColors.lightSecondary;

    // Map tab index (skip the FAB slot at 2)
    // Real pages: 0=Home, 1=Explore, 2=Notifications, 3=Profile
    final pages = [
      HomeFeedPage(
        themeMode: widget.themeMode,
        onToggleTheme: widget.onToggleTheme,
        currentUser: widget.currentUser,
        onNotificationsTap: _onNotifTapped, // ← wire bell icon
      ),
      ExplorePage(
        themeMode: widget.themeMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      NotificationsPage(
        themeMode: widget.themeMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      _ProfilePlaceholder(
        themeMode: widget.themeMode,
        currentUser: widget.currentUser,
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      // Use IndexedStack so pages keep their scroll state
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _buildNavBar(navBg, amber, grey),
    );
  }

  Widget _buildNavBar(Color navBg, Color amber, Color grey) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: navBg,
        border: Border(
          top: BorderSide(
            color: _isDark
                ? AndroColors.darkDivider
                : AndroColors.lightDivider,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            iconOutline: Icons.home_outlined,
            label: 'Home',
            isActive: _currentIndex == 0,
            activeColor: amber,
            inactiveColor: grey,
            onTap: () => _onTabTapped(0),
          ),
          _NavItem(
            icon: Icons.search_rounded,
            iconOutline: Icons.search_outlined,
            label: 'Explore',
            isActive: _currentIndex == 1,
            activeColor: amber,
            inactiveColor: grey,
            onTap: () => _onTabTapped(1),
          ),
          // ── Centre FAB ─────────────────────────────────────────────────
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Create new post'),
                  backgroundColor:
                      _isDark ? AndroColors.darkAccent : AndroColors.lightAccent,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: amber,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: amber.withAlpha(102),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Notifications (visual slot 3 → page index 2) ──────────────
          Stack(
            clipBehavior: Clip.none,
            children: [
              _NavItem(
                icon: Icons.notifications_rounded,
                iconOutline: Icons.notifications_outlined,
                label: 'Notifs',
                isActive: _currentIndex == 2,   // page index 2
                activeColor: amber,
                inactiveColor: grey,
                onTap: _onNotifTapped,           // dedicated handler
              ),
              if (_unreadNotifications > 0)
                Positioned(
                  top: 6,
                  right: 10,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$_unreadNotifications',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // ── Profile (visual slot 4 → page index 3) ────────────────────
          _NavItem(
            icon: Icons.person_rounded,
            iconOutline: Icons.person_outlined,
            label: 'Profile',
            isActive: _currentIndex == 3,      // page index 3
            activeColor: amber,
            inactiveColor: grey,
            onTap: _onProfileTapped,            // dedicated handler
          ),
        ],
      ),
    );
  }
}

// ── Nav item widget ──────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconOutline;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.iconOutline,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? icon : iconOutline,
                key: ValueKey(isActive),
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Profile placeholder ──────────────────────────────────────────────────────

class _ProfilePlaceholder extends StatelessWidget {
  final ThemeMode themeMode;
  final Map<String, String> currentUser;

  const _ProfilePlaceholder({
    required this.themeMode,
    required this.currentUser,
  });

  bool get _isDark => themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final bg     = _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
    final surface = _isDark ? AndroColors.darkSurface    : AndroColors.lightSurface;
    final amber  = _isDark ? AndroColors.darkAmber       : AndroColors.lightAmber;
    final text   = _isDark ? AndroColors.darkText        : AndroColors.lightText;
    final sub    = _isDark ? AndroColors.darkSecondary   : AndroColors.lightSecondary;
    final name   = currentUser['name'] ?? 'User';

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: text,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: amber.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: amber, width: 2.5),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: amber,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              name,
              style: TextStyle(
                color: text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              currentUser['email'] ?? '',
              style: TextStyle(color: sub, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1B3A6B).withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF3D72F0).withOpacity(0.4)),
              ),
              child: Text(
                'ALU Kigali · Trimester 3',
                style: TextStyle(
                  color: const Color(0xFF3D72F0),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      count: '5',
                      label: 'RSVPs',
                      color: amber,
                    ),
                    Container(width: 1, height: 40, color: sub.withOpacity(0.2)),
                    _StatItem(
                      count: '3',
                      label: 'Applied',
                      color: const Color(0xFF22C55E),
                    ),
                    Container(width: 1, height: 40, color: sub.withOpacity(0.2)),
                    _StatItem(
                      count: '12',
                      label: 'Saved',
                      color: const Color(0xFF4A7CF7),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _StatItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8A8AA8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
