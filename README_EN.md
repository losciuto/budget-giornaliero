# Daily Budget

A cross-platform application (Android, Linux, Windows) to calculate the daily budget available until a specific date of the current month.

**Current Version:** 2.3.0 (Flutter)

## 🚀 New Flutter Version

The project has been completely rewritten in **Flutter** to ensure better performance and a modern user experience.
The source code is located in the `flutter_app/` folder.

### Key Features
*   **Automatic Calculation**: Remaining days and daily budget.
*   **Configurable Date**: Intuitive date picker.
*   **Expense Management**: Add expenses with swipe-to-delete.
*   **Notifications**: Daily reminder of remaining budget.
*   **Excel Export**: Export expense report to .xlsx format.
*   **Internationalization**: Italian/English support.
*   **Customizable Currencies**: Support for over 20 currencies (EUR, USD, GBP, etc.) selectable from settings.
*   **Search & Filters**: Advanced search by description, category, and date.
*   **Statistics**: Pie and bar charts to analyze expenses.
*   **Backup & Restore**: Save and load data in JSON format.
*   **Smart Suggestions**: Intelligent expense analysis with personalized tips.
*   **Modern Design**: Material Design 3 with dark/light theme support.
*   **Cross-Platform**: Native support for Android, Linux Desktop, and **Windows**.

### Quick Start
To start developing or running the Flutter version:

1.  Ensure you have the [Flutter SDK](https://flutter.dev) installed.
2.  Enter the app folder:
    ```bash
    cd flutter_app
    ```
3.  Run the app:
    ```bash
    flutter run
    ```

See the [Flutter README](flutter_app/README_EN.md) for detailed instructions on testing, building, and Android Studio configuration.

---

## 🐍 Legacy Version (Python/Kivy)

The original version written in Python and Kivy is still available in the `native_app/` folder, but it is no longer actively maintained.

### Legacy Instructions (Linux)
1.  Create a virtual environment: `python3 -m venv venv`
2.  Activate: `source venv/bin/activate`
3.  Install dependencies: `pip install -r native_app/requirements.txt`
4.  Run: `python native_app/main.py`

For details on the old Android build with Buildozer, see the files in the `native_app/` folder.

## Credits
*   **Author**: Massimo Lo Sciuto
*   **Support**: Antigravity
*   **Development**: Gemini 3 Pro
