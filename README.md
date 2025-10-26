# DailyFlow - Daily Routine Management App

A Flutter application for managing daily routines with local notifications. Built with Material 3 design and follows modern Flutter development practices.

## Features

- Create, edit, and delete routine items
- Set one-time or recurring routines (daily, weekly, custom)
- Receive local notifications for routines
- Snooze or mark routines as done from notifications
- Persist routines across app restarts and device reboots
- Light/dark theme support
- Modern Material 3 design

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Local Storage**: Hive
- **Notifications**: flutter_local_notifications
- **Background Tasks**: android_alarm_manager_plus
- **UI Animations**: animations package
- **Utilities**: intl, uuid, timezone

## Project Structure

```
lib/
  ├── models/
  │   └── routine_item.dart
  ├── providers/
  │   └── routine_provider.dart
  ├── services/
  │   ├── storage_service.dart
  │   ├── notification_service.dart
  │   └── schedule_service.dart
  ├── screens/
  │   ├── home_screen.dart
  │   ├── add_edit_routine.dart
  │   └── settings_screen.dart
  ├── widgets/
  │   └── routine_card.dart
  ├── utils/
  │   └── app_theme.dart
  └── main.dart
```

## Setup & Build Instructions

1. **Prerequisites**:
   - Flutter SDK (latest stable version)
   - Android Studio/VS Code with Flutter extensions
   - Android device/emulator

2. **Clone & Install Dependencies**:
   ```bash
   git clone <repository-url>
   cd daily-flow
   flutter pub get
   ```

3. **Generate Hive Adapters**:
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the App**:
   ```bash
   flutter run
   ```

5. **Build Release APK**:
   ```bash
   flutter build apk --release
   ```

## Architecture & Implementation Details

### Storage
- Uses Hive for efficient local storage
- RoutineItem model with Hive type adapters
- CRUD operations in StorageService

### Notifications
- Local notifications with exact timing
- Supports notification actions (snooze, mark done)
- Reschedules notifications after device reboot
- Uses Android AlarmManager for reliable scheduling

### State Management
- Riverpod for state management
- RoutineProvider handles all routine-related state
- Separate providers for theme and settings

### UI/UX
- Material 3 design with light/dark themes
- Smooth animations using the animations package
- Responsive layout that adapts to different screen sizes

## Testing

Run tests using:
```bash
flutter test
```

Includes:
- Unit tests for models and services
- Widget tests for UI components
- Integration tests for key user flows

## Android Permissions

Required permissions (in AndroidManifest.xml):
- RECEIVE_BOOT_COMPLETED
- WAKE_LOCK
- SCHEDULE_EXACT_ALARM
- USE_EXACT_ALARM
- POST_NOTIFICATIONS (for Android 13+)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
