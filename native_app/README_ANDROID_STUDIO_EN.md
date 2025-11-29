# Usage with Android Studio (LEGACY)

> [!WARNING]
> **This documentation refers to the old Python/Kivy version.**
> For the new Flutter version, simply open the `flutter_app/android` folder in Android Studio.

# Usage with Android Studio

This project supports exporting to an **Android Studio** compatible project. This allows you to use the official Android IDE to compile, sign, and debug the application, instead of relying exclusively on the Buildozer command line.

## Prerequisites

*   **Buildozer**: Must be installed and configured (see main `README.md`).
*   **Android Studio**: Must be installed on your system.

## How to Export the Project

1.  Open a terminal in the `native_app` folder.
2.  Run the export script:
    ```bash
    python3 export_to_android_studio.py
    ```
    *This command will run buildozer to prepare the necessary files and create an `android_studio_project` folder.*

## How to Open in Android Studio

1.  Start **Android Studio**.
2.  Click on **Open** (or **File > Open**).
3.  Navigate to the project folder and select the `native_app/android_studio_project` directory.
4.  Wait for Gradle to complete synchronization (it may take a few minutes the first time).

## Important Notes

*   **Python Code Changes**: If you modify `main.py` or other Python/KV files, **you must re-run the export script**. Android Studio handles Java/Kotlin compilation, but Python code is packaged by Buildozer.
*   **Buildozer Configuration**: Changes to `buildozer.spec` (e.g., permissions, icons) also require a new export.
