# Daily Budget - Flutter App

This is the modern version of the Daily Budget application, entirely rewritten in Flutter.

## Project Structure

*   `lib/main.dart`: Entry point of the application and User Interface (UI).
*   `lib/logic.dart`: Business logic (days and budget calculation).
*   `test/`: Unit tests and Widget tests.
*   `android/`: Native Android project (configurable in Android Studio).
*   `linux/`: Configuration for Linux Desktop builds.

## Getting Started

### Prerequisites
*   [Flutter SDK](https://flutter.dev/docs/get-started/install) installed and configured in PATH.
*   A code editor (VS Code or Android Studio) with Flutter/Dart plugins installed.

### Running
1.  Get dependencies:
    ```bash
    flutter pub get
    ```
2.  Start the app (select target device if necessary):
    ```bash
    flutter run
    ```

### Testing
To verify that everything works correctly:
```bash
flutter test
```

## Android Studio
For specific changes to the Android part (e.g., `AndroidManifest.xml`, `build.gradle`):
1.  Open Android Studio.
2.  Select **Open**.
3.  Choose the `android` folder inside `flutter_app` (NOT the main `flutter_app` folder).

## Build for Release

### Android (APK)
```bash
flutter build apk --release
```
The APK will be generated in `build/app/outputs/flutter-apk/app-release.apk`.

### Linux
```bash
flutter build linux --release
```
The executable will be in `build/linux/x64/release/bundle/`.
