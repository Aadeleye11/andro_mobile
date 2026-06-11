import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_colors.dart';
import '../models/andro_models.dart';

class NotificationsPage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const NotificationsPage({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool get _isDark => widget.themeMode == ThemeMode.dark;

  // Local mutable copy — keyed by id for stable dismissal
  // NOT late — initialized eagerly so hot reload (reassemble) works
  List<_NotifItem> _items = [];

  @override
  void initState() {
    super.initState();
    _initItems();
  }

  /// Also called by Flutter during hot reload — keeps _items valid.
  @override
  void reassemble() {
    super.reassemble();
    _initItems();
  }

  void _initItems() {
    _items = sampleNotifications
        .map((n) => _NotifItem(
              id: n.id,
              title: n.title,
              body: n.body,
              timeAgo: n.timeAgo,
              icon: n.icon,
              iconColor: n.iconColor,
              isRead: n.isRead,
              group: n.isRead ? _Group.earlier : _Group.newNotif,
            ))
        .toList();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _markAllRead() {
    HapticFeedback.lightImpact();
    setState(() {
      for (final item in _items) {
        item.isRead = true;
        item.group = _Group.earlier;
      }
    });
  }

  void _dismissById(String id) {
    setState(() => _items.removeWhere((i) => i.id == id));
  }

  void _markReadById(String id) {
    setState(() {
      final item = _items.firstWhere((i) => i.id == id);
      item.isRead = true;
      item.group = _Group.earlier;
    });
  }

  // ── Grouped getters ───────────────────────────────────────────────────────

  List<_NotifItem> get _newItems =>
      _items.where((i) => i.group == _Group.newNotif).toList();

  List<_NotifItem> get _earlierItems =>
      _items.where((i) => i.group == _Group.earlier).toList();

  int get _unreadCount => _items.where((i) => !i.isRead).length;

  @override
  Widget build(BuildContext context) {
    final bg     = _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
    final accent = _isDark ? AndroColors.darkAccent     : AndroColors.lightAccent;
    final text   = _isDark ? AndroColors.darkText       : AndroColors.lightText;
    final sub    = _isDark ? AndroColors.darkSecondary  : AndroColors.lightSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            _buildHeader(text, sub, accent),

            const SizedBox(height: 16),

            // ── List ─────────────────────────────────────────────────────
            Expanded(
              child: _items.isEmpty
                  ? _buildEmptyState(sub, text)
                  : _buildList(sub),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(Color text, Color sub, Color accent) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  color: text,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (_unreadCount > 0)
                GestureDetector(
                  onTap: _markAllRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accent.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mark all read',
                      style: TextStyle(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _unreadCount > 0
                ? '$_unreadCount unread notification${_unreadCount == 1 ? '' : 's'}'
                : 'You\'re all caught up! ✓',
            style: TextStyle(
              color: _unreadCount > 0
                  ? (_isDark ? AndroColors.darkAmber : AndroColors.lightAmber)
                  : (_isDark ? AndroColors.darkSecondary : AndroColors.lightSecondary),
              fontSize: 13,
              fontWeight: _unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ── Notification list ─────────────────────────────────────────────────────

  Widget _buildList(Color sub) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
      children: [
        // New / Unread section
        if (_newItems.isNotEmpty) ...[
          _SectionHeader(
            label: 'NEW',
            sub: sub,
            badge: _newItems.length,
            isDark: _isDark,
          ),
          const SizedBox(height: 10),
          ..._newItems.map((item) => _buildDismissible(item, isNew: true)),
          const SizedBox(height: 24),
        ],

        // Earlier / Read section
        if (_earlierItems.isNotEmpty) ...[
          _SectionHeader(label: 'EARLIER', sub: sub, isDark: _isDark),
          const SizedBox(height: 10),
          ..._earlierItems
              .map((item) => _buildDismissible(item, isNew: false)),
        ],
      ],
    );
  }

  // ── Dismissible wrapper ───────────────────────────────────────────────────

  Widget _buildDismissible(_NotifItem item, {required bool isNew}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        // Stable key by id — prevents wrong-item deletion
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        // confirmDismiss gives user visual feedback before removal
        confirmDismiss: (direction) async {
          HapticFeedback.mediumImpact();
          return true;
        },
        onDismissed: (_) => _dismissById(item.id),
        background: _DismissBackground(isDark: _isDark),
        child: GestureDetector(
          onTap: () {
            if (!item.isRead) _markReadById(item.id);
          },
          child: _NotificationTile(
            item: item,
            isDark: _isDark,
            isNew: isNew,
          ),
        ),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(Color sub, Color text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: _isDark ? AndroColors.darkSurface : AndroColors.lightSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              color: sub,
              size: 38,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No notifications',
            style: TextStyle(
              color: text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'We\'ll notify you when something new happens on campus.',
              style: TextStyle(color: sub, fontSize: 13, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal mutable item — owns its read/group state locally
// ─────────────────────────────────────────────────────────────────────────────

enum _Group { newNotif, earlier }

class _NotifItem {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  bool isRead;
  _Group group;

  _NotifItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    required this.isRead,
    required this.group,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color sub;
  final int? badge;
  final bool isDark;

  const _SectionHeader({
    required this.label,
    required this.sub,
    this.badge,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: sub,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$badge',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dismiss background (red slide-to-delete)
// ─────────────────────────────────────────────────────────────────────────────

class _DismissBackground extends StatelessWidget {
  final bool isDark;
  const _DismissBackground({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withAlpha(38),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEF4444).withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Delete',
            style: TextStyle(
              color: const Color(0xFFEF4444).withAlpha(230),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFEF4444),
            size: 22,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification tile
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final _NotifItem item;
  final bool isDark;
  final bool isNew;

  const _NotificationTile({
    required this.item,
    required this.isDark,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    final surface  = isDark ? AndroColors.darkSurface  : AndroColors.lightSurface;
    final surface2 = isDark ? AndroColors.darkSurface2 : AndroColors.lightSurface2;
    final text     = isDark ? AndroColors.darkText     : AndroColors.lightText;
    final sub      = isDark ? AndroColors.darkSecondary : AndroColors.lightSecondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isNew ? surface2 : surface,
        borderRadius: BorderRadius.circular(14),
        border: isNew
            ? Border.all(
                color: item.iconColor.withAlpha(51),
                width: 1,
              )
            : Border.all(
                color: isDark
                    ? AndroColors.darkDivider
                    : AndroColors.lightDivider,
                width: 0.5,
              ),
        boxShadow: isNew
            ? [
                BoxShadow(
                  color: item.iconColor.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon container ──────────────────────────────────────────
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconColor.withAlpha(31),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 21),
          ),
          const SizedBox(width: 12),

          // ── Text content ────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: text,
                          fontSize: 13,
                          fontWeight: isNew
                              ? FontWeight.w800
                              : FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.timeAgo,
                      style: TextStyle(
                        color: sub.withAlpha(179),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: TextStyle(
                    color: isNew ? sub : sub.withAlpha(179),
                    fontSize: 12,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Tap to read hint for new notifications
                if (isNew) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Tap to mark as read',
                    style: TextStyle(
                      color: item.iconColor.withAlpha(179),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Unread indicator dot ────────────────────────────────────
          if (!item.isRead) ...[
            const SizedBox(width: 8),
            Container(
              width: 9,
              height: 9,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: item.iconColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: item.iconColor.withAlpha(128),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
