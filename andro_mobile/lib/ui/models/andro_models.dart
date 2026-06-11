// ── Shared data models & mock data ──────────────────────────────────────────
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AndroEvent
// ─────────────────────────────────────────────────────────────────────────────
class AndroEvent {
  final String id;
  final String title;
  final String category;        // 'Hackathon' | 'Workshop' | 'Conference' | 'Talk'
  final String organizer;
  final String date;
  final String location;
  final String description;
  final int going;
  final int interested;
  final bool isFeatured;
  final Color gradientStart;
  final Color gradientEnd;
  final IconData icon;

  const AndroEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.organizer,
    required this.date,
    required this.location,
    required this.description,
    required this.going,
    required this.interested,
    this.isFeatured = false,
    required this.gradientStart,
    required this.gradientEnd,
    required this.icon,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// AndroOpportunity
// ─────────────────────────────────────────────────────────────────────────────
class AndroOpportunity {
  final String id;
  final String title;
  final String type;            // 'Internship' | 'Competition' | 'Fellowship' | 'Scholarship'
  final String organization;
  final String deadline;
  final String description;
  final IconData icon;
  final Color iconColor;

  const AndroOpportunity({
    required this.id,
    required this.title,
    required this.type,
    required this.organization,
    required this.deadline,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// AndroNotification
// ─────────────────────────────────────────────────────────────────────────────
class AndroNotification {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  bool isRead;

  AndroNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Sample Data
// ─────────────────────────────────────────────────────────────────────────────

final AndroEvent featuredEvent = AndroEvent(
  id: 'f1',
  title: 'ALU Entrepreneurship Summit 2025',
  category: 'Conference',
  organizer: 'ALU Kigali',
  date: 'Wed 14 Aug · 18:00',
  location: 'Kigali Campus',
  description:
      'Pitches · Panels · Networking · Kigali Campus. Join the most impactful entrepreneurship event of the year featuring Africa\'s top founders, investors, and innovators.',
  going: 210,
  interested: 540,
  isFeatured: true,
  gradientStart: const Color(0xFF1B3A6B),
  gradientEnd: const Color(0xFF2D5FBE),
  icon: Icons.rocket_launch_rounded,
);

final List<AndroEvent> upcomingEvents = [
  AndroEvent(
    id: 'e1',
    title: '48h Tech Hackathon: Smart Cities',
    category: 'Hackathon',
    organizer: 'ALU Tech Club',
    date: '23–25 Aug',
    location: 'Innovation Lab',
    description:
        'A 48-hour hackathon where teams build solutions for smart city challenges. Open to all ALU students.',
    going: 67,
    interested: 142,
    gradientStart: const Color(0xFF1B3A8A),
    gradientEnd: const Color(0xFF3D72F0),
    icon: Icons.laptop_mac_rounded,
  ),
  AndroEvent(
    id: 'e2',
    title: 'Sustainable Business Workshop',
    category: 'Workshop',
    organizer: 'Business Club',
    date: 'Fri 16 Aug',
    location: 'Room C-201',
    description:
        'A hands-on workshop exploring sustainable business models, impact measurement, and ESG frameworks for African businesses.',
    going: 24,
    interested: 58,
    gradientStart: const Color(0xFF14532D),
    gradientEnd: const Color(0xFF16A34A),
    icon: Icons.eco_rounded,
  ),
  AndroEvent(
    id: 'e3',
    title: 'Leadership & Public Speaking',
    category: 'Talk',
    organizer: 'Student Affairs',
    date: 'Mon 19 Aug',
    location: 'Amphitheatre',
    description:
        'A session with ALU alumni leaders sharing insights on effective communication, storytelling, and leading with purpose.',
    going: 45,
    interested: 98,
    gradientStart: const Color(0xFF4A1D96),
    gradientEnd: const Color(0xFF7C3AED),
    icon: Icons.mic_rounded,
  ),
];

final List<AndroOpportunity> latestOpportunities = [
  AndroOpportunity(
    id: 'o1',
    title: 'Product Design Intern — Andela',
    type: 'Internship',
    organization: 'Andela',
    deadline: 'Closes 20 Aug',
    description:
        'Join Andela\'s product team as a design intern. Work on real user research, prototyping, and product launches across Africa.',
    icon: Icons.design_services_rounded,
    iconColor: const Color(0xFF4A7CF7),
  ),
  AndroOpportunity(
    id: 'o2',
    title: 'Africa Innovation Challenge',
    type: 'Competition',
    organization: 'AfriLabs',
    deadline: 'Closes 1 Sep',
    description:
        'A continent-wide innovation competition for student entrepreneurs. Win up to \$10,000 in prizes and mentorship.',
    icon: Icons.emoji_events_rounded,
    iconColor: const Color(0xFFF5A524),
  ),
  AndroOpportunity(
    id: 'o3',
    title: 'Google Africa Developer Scholarship',
    type: 'Scholarship',
    organization: 'Google',
    deadline: 'Closes 30 Aug',
    description:
        'A scholarship program for African developers to build expertise in mobile, web, and cloud technologies.',
    icon: Icons.school_rounded,
    iconColor: const Color(0xFF22C55E),
  ),
  AndroOpportunity(
    id: 'o4',
    title: 'MLH Fellowship — Open Source',
    type: 'Fellowship',
    organization: 'MLH',
    deadline: 'Closes 15 Sep',
    description:
        'A 12-week fellowship where you contribute to open-source projects and build your engineering portfolio.',
    icon: Icons.code_rounded,
    iconColor: const Color(0xFFEC4899),
  ),
];

List<AndroNotification> sampleNotifications = [
  AndroNotification(
    id: 'n1',
    title: 'New event posted!',
    body: 'ALU Entrepreneurship Summit 2025 is now open for RSVPs.',
    timeAgo: '2m ago',
    icon: Icons.event_rounded,
    iconColor: const Color(0xFF4A7CF7),
  ),
  AndroNotification(
    id: 'n2',
    title: 'Application deadline soon',
    body: 'Product Design Intern — Andela closes in 3 days.',
    timeAgo: '1h ago',
    icon: Icons.alarm_rounded,
    iconColor: const Color(0xFFF5A524),
  ),
  AndroNotification(
    id: 'n3',
    title: 'Hackathon reminder',
    body: '48h Tech Hackathon: Smart Cities starts in 2 weeks. Register now!',
    timeAgo: '3h ago',
    icon: Icons.laptop_rounded,
    iconColor: const Color(0xFF22C55E),
    isRead: true,
  ),
  AndroNotification(
    id: 'n4',
    title: 'New opportunity added',
    body: 'Google Africa Developer Scholarship is now live. Apply today!',
    timeAgo: 'Yesterday',
    icon: Icons.school_rounded,
    iconColor: const Color(0xFF4A7CF7),
    isRead: true,
  ),
  AndroNotification(
    id: 'n5',
    title: 'Workshop seats filling up',
    body: 'Sustainable Business Workshop is 80% full. Save your spot.',
    timeAgo: 'Yesterday',
    icon: Icons.eco_rounded,
    iconColor: const Color(0xFF22C55E),
    isRead: true,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Explore categories
// ─────────────────────────────────────────────────────────────────────────────
class ExploreCategory {
  final String label;
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;
  final int count;

  const ExploreCategory({
    required this.label,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.count,
  });
}

final List<ExploreCategory> exploreCategories = [
  ExploreCategory(
    label: 'Hackathons',
    icon: Icons.laptop_mac_rounded,
    gradientStart: const Color(0xFF1B3A8A),
    gradientEnd: const Color(0xFF3D72F0),
    count: 8,
  ),
  ExploreCategory(
    label: 'Opportunities',
    icon: Icons.work_rounded,
    gradientStart: const Color(0xFF14532D),
    gradientEnd: const Color(0xFF16A34A),
    count: 15,
  ),
  ExploreCategory(
    label: 'Conferences',
    icon: Icons.public_rounded,
    gradientStart: const Color(0xFF1B3A6B),
    gradientEnd: const Color(0xFF2D5FBE),
    count: 5,
  ),
  ExploreCategory(
    label: 'Workshops',
    icon: Icons.construction_rounded,
    gradientStart: const Color(0xFF4A1D96),
    gradientEnd: const Color(0xFF7C3AED),
    count: 12,
  ),
  ExploreCategory(
    label: 'Fellowships',
    icon: Icons.handshake_rounded,
    gradientStart: const Color(0xFF831843),
    gradientEnd: const Color(0xFFEC4899),
    count: 6,
  ),
  ExploreCategory(
    label: 'Scholarships',
    icon: Icons.school_rounded,
    gradientStart: const Color(0xFF7C2D12),
    gradientEnd: const Color(0xFFF97316),
    count: 9,
  ),
];
