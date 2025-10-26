# Agentic AI Prompt — Flutter Daily Routine (Android) App

> **Purpose:** Instruct an agentic AI (or a developer agent) to build a complete, production-ready Android Flutter app that lets a user add a daily routine and receive timely alerts (local notifications). UI should be modern and appealing.

---

## 1) Project Overview

**App name (placeholder):** DailyFlow

**Platform:** Android (APK / AAB)

**Tech stack (preferred):**
- Flutter (stable, latest LTS that supports Android 12/13/14)
- State management: Riverpod (or Provider if Riverpod unavailable)
- Local storage: Hive (or sqflite as fallback)
- Notifications: flutter_local_notifications + timezone package
- Background scheduling: Android AlarmManager integration where necessary, plus rescheduling on reboot

**High-level goals:**
1. Allow user to create, edit, delete routine items with scheduled times.
2. Trigger reliable local notifications/alerts at scheduled times on Android.
3. Support one-time and repeating schedules (daily, weekdays, custom recurrence).
4. Provide an attractive, responsive UI with Material 3 styling, light/dark themes, and micro-animations.
5. Persist routines on device; maintain schedules across reboots.
6. Provide clear developer deliverables: full source repo, README, build instructions, signed debug-release APK/AAB.

---

## 2) Minimal Viable Product (MVP) Requirements

1. Add routine item: title, optional description, time, repeat (none/daily/weekly/custom), optional reminder offset (e.g., 10 min before).
2. Edit and delete routine items.
3. Local notification fires at the scheduled time with title + description and action buttons: `Snooze 5m`, `Mark Done`.
4. Notifications persist across device reboots (reschedule on boot).
5. Data persisted locally using Hive (or sqflite) with a sensible schema.
6. Clean, modern UI: home list of today's routines, add/edit screen, settings screen (theme, notification sound, snooze duration).
7. Basic unit tests for core logic (scheduling/rescheduling) and at least one widget test for Add Routine screen.

---

## 3) Nice-to-have / Post-MVP

- Google Drive/Dropbox backup & restore (optional)
- Widgets (Android home screen) to show upcoming routines
- Smart suggestions (auto-suggest frequent items)
- Recurring exceptions (skip on specific dates)
- Analytics for usage (opt-in)
- Localization: English + one additional language
- Accessibility improvements: TalkBack support, high-contrast theme

---

## 4) UI / UX Guidelines

- Use Material 3 components where possible.
- Clean typography, ample spacing, subtle shadows and rounded corners (2xl radius for cards).
- Primary layout:
  - **Home**: A vertical list grouped by day/time (Today/Upcoming). Each card shows time, title, small tags (repeat, snooze).
  - **Add/Edit**: Form with title, description, time picker, repeat options, reminder offset.
  - **Settings**: Theme switch, notification preferences.
- Provide subtle entrance animations (use Framer Motion equivalent in Flutter — `animations` package or implicit animations) for adding/removing items.
- Use a pleasant color palette (example: deep purple/teal accent); provide both light and dark versions.

---

## 5) Data Model (suggested)

```dart
class RoutineItem {
  String id; // uuid v4
  String title;
  String? description;
  DateTime time; // local time for next occurrence
  bool enabled;
  Recurrence recurrence; // none, daily, weekly, custom
  List<int>? weekdays; // if weekly (1=Mon..7=Sun)
  int reminderMinutesBefore; // e.g., 0 = at time, 10 = 10 minutes before
  DateTime createdAt;
  DateTime updatedAt;
}
```

Persist in Hive box (or SQLite table) and index by `id`.

---

## 6) Notifications & Scheduling Architecture

- Use `flutter_local_notifications` with the `timezone` package to schedule notifications in local timezone.
- When a routine is created/edited/enabled, schedule a notification for the next occurrence using `flutterLocalNotificationsPlugin.zonedSchedule(...)`.
- For repeating schedules, schedule using the plugin's repeat or schedule next occurrence manually after the notification fires (preferred for more control).
- On device reboot (`RECEIVE_BOOT_COMPLETED`), reschedule all enabled routines. Implement a small Android native broadcast receiver or use existing Flutter packages or `android_alarm_manager_plus` to handle this.
- Implement `Snooze` action: when user taps `Snooze 5m`, schedule a single notification 5 minutes later.
- Notification channels (Android 8+) with descriptive names and importance levels.
- Ensure battery optimization considerations: use AlarmManager with setExactAndAllowWhileIdle for critical alarms if higher reliability required.

---

## 7) Android-specific Requirements

- Request and declare required permissions in `AndroidManifest.xml` (e.g., `RECEIVE_BOOT_COMPLETED`).
- Configure `minSdkVersion` to a reasonable level (21+). Ensure compatibility up to Android 14 behavior changes.
- Add notification channel setup on app start.
- Handle Doze mode by using proper AlarmManager APIs for critical alarms and testing on Android power-saving modes.

---

## 8) Packages (recommended `pubspec.yaml` entries)

- flutter_local_notifications
- timezone
- hive
- hive_flutter
- riverpod (or flutter_riverpod)
- intl
- flutter_native_splash
- flutter_launcher_icons
- animations
- android_alarm_manager_plus (if needed)
- shared_preferences (for small settings)
- uuid
- url_launcher (optional for help links)
- flutter_test, mockito / mocktail for tests

---

## 9) File Structure (suggested)

```
/lib
  /models
    routine_item.dart
  /providers
    routine_provider.dart
  /services
    storage_service.dart
    notification_service.dart
    schedule_service.dart
  /screens
    home_screen.dart
    add_edit_routine.dart
    settings_screen.dart
  /widgets
    routine_card.dart
  main.dart

/android
  // AndroidManifest updates, boot receiver, gradle config

/test
  // unit and widget tests

README.md

```

---

## 10) Development Deliverables (what agent must produce)

1. Complete Flutter project repository, ready to build with `flutter pub get` and `flutter build apk`.
2. `README.md` with build & run instructions, list of packages, and testing instructions.
3. Debug-signed APK and/or AAB artifact for Android.
4. Short developer notes on how notifications are scheduled and how reboot handling is implemented.
5. At least 3 unit tests and 2 widget tests demonstrating core behavior.
6. Clear commit history with meaningful messages.

---

## 11) Acceptance Criteria / QA Checklist

- [ ] Can add/edit/delete a routine item.
- [ ] Local notification fires at scheduled time (testable by setting a time a few minutes ahead).
- [ ] Snooze action posts a notification after chosen snooze duration.
- [ ] App reschedules notifications after device reboot.
- [ ] Data persists across app restarts.
- [ ] App compiles and installs on Android API 29+ (test on an emulator or device).
- [ ] UI follows Material 3 look with light/dark mode toggle.
- [ ] At least 3 passing unit tests and 2 widget tests.

---

## 12) Testing Instructions (for the agent)

- Manual: create routines set for 2–5 minutes ahead and verify notification arrives.
- Reboot device/emulator and ensure scheduled notifications still fire.
- Toggle Doze/battery optimization settings to see reliability and document behaviors.
- Run `flutter test` to ensure automated tests pass.

---

## 13) Implementation Steps (Actionable prompts for the agent)

1. **Scaffold project** — initialize Flutter app, add recommended packages.
2. **Implement storage** — Hive adapter for `RoutineItem` with CRUD operations.
3. **Implement notification service** — initialize `flutter_local_notifications`, set channels, timezone setup, helper functions `scheduleRoutineNotification`, `cancelNotification`, `rescheduleAll`.
4. **UI screens** — Home, Add/Edit, Settings with responsive layout and animations.
5. **Action handling** — Notification actions for Snooze and Mark Done.
6. **Boot handling** — Add `RECEIVE_BOOT_COMPLETED` handling to reschedule.
7. **Testing & QA** — add unit/widget tests and produce README with manual test steps.
8. **Build artifacts** — produce debug-signed APK/AAB and full repo zip.

---

## 14) Developer Notes / Constraints

- Target Android only — do not implement iOS-specific code unless requested.
- Keep the code modular and well-documented. Add doc comments to public classes/methods.
- Avoid heavyweight third-party dependencies unless necessary.
- Respect battery life: explain tradeoffs in the dev notes (exact alarms vs. inexact repeats).

---

## 15) Example prompts you can give the agentic AI to start tasks

- `Task 1: Create a Flutter project scaffold with Riverpod, Hive, flutter_local_notifications, timezone, and basic app structure (home/add/settings). Commit and push to repo.`
- `Task 2: Implement Hive model and CRUD, and write unit tests for the storage layer.`
- `Task 3: Implement NotificationService with zoned scheduling and snooze actions. Provide developer notes about how it handles reboot and Doze.`
- `Task 4: Build attractive UI screens with Material 3; include light/dark themes and animations.`
- `Task 5: Create README, run tests, and produce APK.`

---

## 16) Communication / Handoff

When handing off, include:
- How to run: `flutter pub get`, `flutter run`, `flutter build apk --release`.
- How notifications are scheduled and where to change default snooze durations.
- How to reschedule all routines manually (a utility function in `ScheduleService`).

---

## 17) Questions the agent should ask the user (if needed)

> The agent should *not* block on these — if the user did not answer, proceed with sensible defaults.

- Preferred color palette or brand colors? (default: #6A1B9A purple accent)
- Minimum Android API target (default: API 21+)
- Any integrations (backup, cloud) required? (default: none)


---

## 18) License

- MIT license for produced code by default unless the user requests another.

---

**End of instruction file**

