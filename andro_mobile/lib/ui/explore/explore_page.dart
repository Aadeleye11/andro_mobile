import 'package:flutter/material.dart';
import '../theme_colors.dart';
import '../models/andro_models.dart';
import '../home/event_detail_page.dart';
import '../home/opportunity_detail_page.dart';

class ExplorePage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const ExplorePage({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool get _isDark => widget.themeMode == ThemeMode.dark;

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _focused = false;
  final FocusNode _focusNode = FocusNode();

  final List<String> _trendingSearches = [
    'NASA',
    'Flutter',
    'Hackathon',
    'Fellowship',
    'Google',
    'AI',
    'Internship',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Combine all events + opportunities for search
  List<dynamic> get _searchResults {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    final results = <dynamic>[];
    for (final e in [featuredEvent, ...upcomingEvents]) {
      if (e.title.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.organizer.toLowerCase().contains(q) ||
          e.location.toLowerCase().contains(q)) {
        results.add(e);
      }
    }
    for (final o in latestOpportunities) {
      if (o.title.toLowerCase().contains(q) ||
          o.type.toLowerCase().contains(q) ||
          o.organization.toLowerCase().contains(q)) {
        results.add(o);
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final bg      = _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
    final surface = _isDark ? AndroColors.darkSurface     : AndroColors.lightSurface;
    final accent  = _isDark ? AndroColors.darkAccent      : AndroColors.lightAccent;
    final text    = _isDark ? AndroColors.darkText        : AndroColors.lightText;
    final sub     = _isDark ? AndroColors.darkSecondary   : AndroColors.lightSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      color: text,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find events, opportunities & more',
                    style: TextStyle(color: sub, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Search bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _focused
                        ? accent
                        : (_isDark
                            ? AndroColors.darkDivider
                            : AndroColors.lightDivider),
                    width: _focused ? 1.5 : 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  style: TextStyle(color: text, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search events, opportunities...',
                    hintStyle: TextStyle(
                        color: sub.withOpacity(0.6), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: _focused ? accent : sub, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close_rounded,
                                color: sub, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _focusNode.unfocus();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Body ─────────────────────────────────────────────────────
            Expanded(
              child: _query.isNotEmpty
                  ? _buildSearchResults(text, sub, surface, accent)
                  : _buildBrowseView(text, sub, accent),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search results ─────────────────────────────────────────────────────────

  Widget _buildSearchResults(
      Color text, Color sub, Color surface, Color accent) {
    final results = _searchResults;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, color: sub, size: 52),
            const SizedBox(height: 14),
            Text(
              'No results for "$_query"',
              style: TextStyle(
                  color: text, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different keyword',
              style: TextStyle(color: sub, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final item = results[i];
        if (item is AndroEvent) {
          return _SearchEventTile(
            event: item,
            isDark: _isDark,
            surface: surface,
            text: text,
            sub: sub,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailPage(
                  event: item,
                  themeMode: widget.themeMode,
                  onToggleTheme: widget.onToggleTheme,
                ),
              ),
            ),
          );
        } else if (item is AndroOpportunity) {
          return _SearchOpportunityTile(
            opp: item,
            isDark: _isDark,
            surface: surface,
            text: text,
            sub: sub,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OpportunityDetailPage(
                  opp: item,
                  themeMode: widget.themeMode,
                  onToggleTheme: widget.onToggleTheme,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // ── Browse view (when not searching) ──────────────────────────────────────

  Widget _buildBrowseView(Color text, Color sub, Color accent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories grid
          Text(
            'Browse by Category',
            style: TextStyle(
              color: text,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),
            itemCount: exploreCategories.length,
            itemBuilder: (context, i) {
              final cat = exploreCategories[i];
              return _CategoryCard(
                category: cat,
                onTap: () {
                  _searchController.text = cat.label;
                  _focusNode.requestFocus();
                },
              );
            },
          ),

          const SizedBox(height: 28),

          // Trending searches
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending Searches',
                style: TextStyle(
                  color: text,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.trending_up_rounded, color: accent, size: 20),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _trendingSearches.map((s) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = s;
                  _focusNode.unfocus();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isDark
                        ? AndroColors.darkSurface
                        : AndroColors.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isDark
                          ? AndroColors.darkDivider
                          : AndroColors.lightDivider,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up_rounded,
                          color: sub, size: 13),
                      const SizedBox(width: 5),
                      Text(
                        s,
                        style: TextStyle(
                          color: sub,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Card
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final ExploreCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [category.gradientStart, category.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: category.gradientEnd.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(category.icon, color: Colors.white, size: 28),
            const Spacer(),
            Text(
              category.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${category.count} available',
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search result tiles
// ─────────────────────────────────────────────────────────────────────────────

class _SearchEventTile extends StatelessWidget {
  final AndroEvent event;
  final bool isDark;
  final Color surface, text, sub;
  final VoidCallback onTap;

  const _SearchEventTile({
    required this.event,
    required this.isDark,
    required this.surface,
    required this.text,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [event.gradientStart, event.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(event.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      color: text,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${event.category} · ${event.date}',
                    style: TextStyle(color: sub, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: sub.withOpacity(0.5), size: 18),
          ],
        ),
      ),
    );
  }
}

class _SearchOpportunityTile extends StatelessWidget {
  final AndroOpportunity opp;
  final bool isDark;
  final Color surface, text, sub;
  final VoidCallback onTap;

  const _SearchOpportunityTile({
    required this.opp,
    required this.isDark,
    required this.surface,
    required this.text,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: opp.iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: opp.iconColor.withOpacity(0.25), width: 1),
              ),
              child: Icon(opp.icon, color: opp.iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opp.title,
                    style: TextStyle(
                      color: text,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${opp.type} · ${opp.organization}',
                        style: TextStyle(color: sub, fontSize: 11),
                      ),
                      const Spacer(),
                      Text(
                        opp.deadline,
                        style: const TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded,
                color: sub.withOpacity(0.5), size: 18),
          ],
        ),
      ),
    );
  }
}
