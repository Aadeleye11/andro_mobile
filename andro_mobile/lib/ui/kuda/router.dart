import 'package:flutter/widgets.dart';
import 'create_post.dart';
import 'event_detail.dart';
import 'organiser_attendance.dart';
import 'qr_checkin.dart';
import 'campus_map.dart';
import 'resource_library.dart';

Map<String, WidgetBuilder> kudaRoutes() {
  return {
    '/kuda/create': (ctx) => const CreatePostScreen(),
    '/kuda/event': (ctx) => const EventDetailScreen(),
    '/kuda/attendance': (ctx) => const OrganiserAttendanceScreen(),
    '/kuda/qr': (ctx) => const QRCheckInScreen(),
    '/kuda/map': (ctx) => const CampusMapScreen(),
    '/kuda/resources': (ctx) => const ResourceLibraryScreen(),
  };
}
