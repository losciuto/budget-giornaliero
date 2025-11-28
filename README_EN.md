# Daily Budget

A cross-platform application (Linux, Windows, Android) to calculate the daily budget available until a specific date of the current month.

**Version:** 1.1.1

## Features
*   **Automatic Calculation**: Counts the days remaining until the target date (inclusive).
*   **Configurable Date**: Select the budget end date via a convenient calendar (DatePicker).
*   **Budget Division**: Divides the entered amount by the remaining days.
*   **Modern Interface**: Dark Mode theme built with KivyMD.
*   **Info & Credits**: Dedicated window with project details.
*   **Cross-Platform**: Single source code for all platforms.

## Credits
*   **Author**: Massimo Lo Sciuto
*   **Support**: Antigravity
*   **Development**: Gemini 3 Pro

## Project Structure
The source code is located in the `native_app/` folder.

## Usage and Compilation Instructions

### 🐧 Linux (Mint, Ubuntu, Debian)

To run the application without "polluting" the system, it is recommended to use a virtual environment (`venv`).

1.  **Install system dependencies:**
    ```bash
    sudo apt update
    sudo apt install python3-pip python3-venv libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev xclip xsel
    ```

2.  **Create and activate the virtual environment** (in the project folder):
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    ```

3.  **Install Python libraries:**
    ```bash
    pip install -r native_app/requirements.txt
    ```

4.  **Start the App:**
    ```bash
    python native_app/main.py
    ```

5.  **Create Executable (Optional):**
    ```bash
    pip install "pyinstaller<6.0"
    pyinstaller --onefile --windowed --name="BudgetGiornaliero" native_app/main.py
    ```

---

### 🪟 Windows

To create a working `.exe` file, you must perform these steps **on a Windows PC**.

1.  Install [Python](https://www.python.org/) (select "Add to PATH" during installation).
2.  Open the terminal (PowerShell or CMD) in the project folder.
3.  Install dependencies:
    ```powershell
    pip install -r native_app/requirements.txt
    pip install "pyinstaller<6.0"
    ```
4.  Create the executable:
    ```powershell
    pyinstaller --onefile --windowed --name="BudgetGiornaliero" native_app/main.py
    ```
5.  You will find the `BudgetGiornaliero.exe` file in the `dist` folder.

---

### 🤖 Android

To compile the Android APK, you need to use **Buildozer** on a **Linux** system (or WSL on Windows).

1.  **Install system dependencies** (Ubuntu/Debian):
    ```bash
    sudo apt update
    sudo apt install -y git zip unzip openjdk-17-jdk python3-pip autoconf libtool pkg-config zlib1g-dev libncurses5-dev libncursesw5-dev libtinfo5 cmake libffi-dev libssl-dev
    ```

2.  **Install Buildozer**:
    ```bash
    pip3 install --user buildozer
    ```

3.  **Build the APK**:
    ```bash
    cd native_app
    buildozer android debug
    ```

4.  The APK will be generated in `native_app/bin/budgetgiornaliero-1.0-debug.apk`.

5.  Transfer the APK to your Android smartphone and install it.

> **Note**: The first build will take a long time (30-60 minutes) because Buildozer will download Android SDK, NDK, and other dependencies.

