# AlarmCat - Flutter Alarm Application

## Overview
AlarmCat is a feature-rich alarm application built with Flutter. It allows users to manage alarms with customizable categories, specific settings, and various premium features. The app is designed with an appealing interface and offers a range of functionalities to enhance the user experience.

## Features
- **Customizable Categories**: Users can create and manage alarm categories with toggling options.
- **Category-Specific Settings**: Set ringtones/sounds, vibration patterns, and snooze durations for each category.
- **Standard Alarm Settings**: Create one-time alarms with options to delete after dismissal.
- **Gentle Wake-Up**: Gradually increase alarm volume for a more pleasant waking experience.
- **Pre-Alarms/Reminders**: Set reminders before the main alarm time.
- **Notes/Reminders within Alarms**: Add notes to alarms for additional context.
- **Cloud Backup and Sync**: Premium feature for backing up and syncing user data across devices.
- **Widgets**: Home screen widgets for quick access to alarms.
- **Theme/Personalization**: Customize the app's appearance with various themes and colors.
- **Location-Based Alarms**: Premium feature to set alarms based on user location.
- **Weather Integration**: Premium feature that adjusts alarms based on weather conditions.
- **Spotify/Music Service Integration**: Premium feature to use music from Spotify or other services as alarm sounds.

## Project Structure
```
alarmcat
├── lib
│   ├── main.dart
│   ├── app.dart
│   ├── models
│   │   ├── alarm.dart
│   │   ├── category.dart
│   │   ├── settings.dart
│   │   └── user.dart
│   ├── services
│   │   ├── alarm_service.dart
│   │   ├── notification_service.dart
│   │   ├── cloud_sync_service.dart
│   │   ├── location_service.dart
│   │   ├── weather_service.dart
│   │   └── music_service.dart
│   ├── providers
│   │   ├── alarm_provider.dart
│   │   ├── category_provider.dart
│   │   └── theme_provider.dart
│   ├── screens
│   │   ├── home_screen.dart
│   │   ├── alarm_edit_screen.dart
│   │   ├── category_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── premium_screen.dart
│   │   └── splash_screen.dart
│   ├── widgets
│   │   ├── alarm_tile.dart
│   │   ├── category_tile.dart
│   │   ├── alarm_widget.dart
│   │   └── theme_picker.dart
│   ├── themes
│   │   ├── app_theme.dart
│   │   └── colors.dart
│   └── utils
│       ├── constants.dart
│       └── helpers.dart
├── test
│   ├── alarm_test.dart
│   ├── category_test.dart
│   └── widget_test.dart
├── pubspec.yaml
└── README.md
```

## Getting Started
1. Clone the repository:
   ```
   git clone https://github.com/yourusername/alarmcat.git
   ```
2. Navigate to the project directory:
   ```
   cd alarmcat
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the application:
   ```
   flutter run
   ```

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.

## License
This project is licensed under the MIT License - see the LICENSE file for details.