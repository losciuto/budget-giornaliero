# Daily Budget - Flutter App

[Versione Italiana](README.md)

Modern daily budget management application, entirely developed in Flutter.

## 📱 Features

- **Daily Budget Calculation**: Automatically calculates how much you can spend per day based on total budget and remaining days
- **Expense Management**: Add, view, and delete expenses with swipe-to-delete
- **Running Balance**: View remaining balance after each expense
- **Multilingual**: Support for 5 languages (Italian, English, Spanish, French, German)
- **Multi-currency**: Support for 20+ currencies (EUR, USD, GBP, JPY, CHF, CAD, AUD, CNY, INR, BRL, RUB, KRW, MXN, ZAR, SEK, NOK, DKK, PLN, TRY, AED)
- **Daily Notifications**: Daily reminders of available budget (Android, Windows, Linux)
- **Search & Filters**: Advanced search by description, category, and date
- **Statistics**: Pie and bar charts to analyze expenses
- **Backup & Restore**: Save and load data in JSON format
- **Smart Suggestions**: Intelligent expense analysis with personalized tips
- **Excel Export**: Export budget summary and expenses to Excel format with professional formatting
- **Quick Clear**: Delete all expenses with a single tap
- **Cross-platform**: Available for Android, Linux Desktop, and Windows

## 🏗️ Project Structure

### Architecture (v2.5.0+)
The application follows a layered architecture with separation of concerns:

- `lib/main.dart`: Entry point and main user interface
- `lib/services/`: Service layer for business logic
  - `storage_service.dart`: Data persistence management (SharedPreferences)
  - `excel_service.dart`: Excel format export
  - `notification_service.dart`: Cross-platform notifications
- `lib/widgets/`: Reusable widgets
  - `add_expense_dialog.dart`: Expense addition dialog
- `lib/logic.dart`: Budget calculation logic and data models
- `lib/statistics_screen.dart`: Statistics screen
- `lib/search_filter_screen.dart`: Search and filters
- `lib/smart_features.dart`: Smart suggestions
- `lib/backup_manager.dart`: Backup/restore management
- `lib/app_strings.dart`: Localized strings
- `test/`: Unit tests and Widget tests
- `android/`: Native Android project
- `linux/`: Linux build configuration
- `windows/`: Windows build configuration
- `assets/`: Resources (icons)

> 📖 For details on v2.5.0 refactoring, see [REFACTORING_EN.md](REFACTORING_EN.md)

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed and configured in PATH
- A code editor (VS Code or Android Studio) with Flutter/Dart plugins installed
- **Android Build**: Requires NDK version 27.0.12077973 or higher and Java 8 core library desugaring support (already configured in `build.gradle`)

### Running
1. Get dependencies:
   ```bash
   flutter pub get
   ```
2. Start the app (select target device if necessary):
   ```bash
   flutter run
   ```

### Testing
To verify that everything works correctly:
```bash
flutter test
```

## 🔧 Android Studio
For specific changes to the Android part (e.g., `AndroidManifest.xml`, `build.gradle`):
1. Open Android Studio
2. Select **Open**
3. Choose the `android` folder inside `flutter_app` (NOT the main `flutter_app` folder)

## 📦 Build for Release

### Android (APK)
```bash
flutter build apk --release
```
The APK will be generated in `build/app/outputs/flutter-apk/app-release.apk`.

### Linux
```bash
flutter build linux --release
```
The executable will be in `build/linux/x64/release/bundle/budget_giornaliero`.

## 🎨 Icon Customization

To modify the app icon:
1. Replace `assets/icon.png` with your icon (1024x1024 px recommended)
2. Run:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

## 📚 Main Dependencies

- `flutter_localizations`: Internationalization
- `google_fonts`: Custom fonts
- `shared_preferences`: Local data persistence
- `flutter_local_notifications`: Push notifications
- `excel`: Excel file export
- `path_provider`: Filesystem access
- `intl`: Date and currency formatting

## 👨‍💻 Author

**[losciuto](https://github.com/losciuto/budget-giornaliero)**

Developed with support from Antigravity and Gemini 3 Pro

## 📄 Version

**2.7.1** - Periodic Reports (January 2026)

### What's New in v2.7.0

- **Periodic Reports**: New complete dashboard for daily, weekly, monthly, and yearly reports
- **Interactive Charts**: Bar charts for immediate visualization of spending trends
- **Time Navigation**: Easily browse through past and future periods (days, weeks, months, years)

### What's New in v2.6.2

- **New Categories**: Added categories for "Mara's Expenses", "Cash", and "Medicines"

### What's New in v2.6.1

- **International Documentation**: All main technical documentation translated into English
- **Version Consistency**: Version alignment across all release files

### What's New in v2.6.0

- **Android Backup Folder**: Backups are now saved to the public Download folder for better accessibility
- **Optimized Permissions**: Automatic storage permission handling for all Android versions

### What's New in v2.5.0
- 🏗️ Improved architecture with service layer
- 📦 More modular and maintainable code (-23.6% complexity)
- 🧪 Better component testability
- 📚 See [CHANGELOG.md](CHANGELOG.md) for complete details
