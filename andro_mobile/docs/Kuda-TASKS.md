Kuda — Assigned Feature Scope

Branch: kuda/events-content-creation

Goal: Work only on Events & Content Creation features and related screens. Keep changes isolated to this branch and under `lib/ui/kuda/` where possible so other people's work isn't modified.

Primary features to implement (MVP scope):
- Post creation flow (Event & Opportunity)
- Event post fields form + validation
- RSVP states UI (Interested / Going / Waitlist)
- Organiser attendance view (counts, attendee list, CSV export)

Extended/optional features (if time):
- QR Code generation / student check-in flow
- Campus map & room locator (map tab in Event Detail)
- Resource library attachments for events

Suggested scaffold files (place new screens in `lib/ui/kuda/`):
- lib/ui/kuda/create_post.dart
- lib/ui/kuda/event_detail.dart
- lib/ui/kuda/organiser_attendance.dart
- lib/ui/kuda/qr_checkin.dart
- lib/ui/kuda/campus_map.dart
- lib/ui/kuda/resource_library.dart

Development notes
- Avoid modifying existing screens in `lib/ui/` unless absolutely necessary; add new widgets under `lib/ui/kuda/` and integrate via routes.
- Use Provider/Riverpod pattern consistent with project (follow existing patterns in `lib/` if present).
- Keep PRs small and focused: one PR per screen/feature.
- Add unit/widget tests for form validation and RSVP state changes where possible.

Next steps you can ask me to do:
- Create the scaffold files (I can add simple widgets now).
- Wire up routes in a local-only router file under `lib/ui/kuda/` so your work doesn't touch main routing yet.
- Push branch to remote and open a PR template for reviewers.

If you want, I can now create the scaffold Dart files listed above in this branch.