# Daily Budget

A cross-platform application (Linux, Windows, Android) to calculate the daily budget available until the 27th of the current month.

## Features
*   **Automatic Calculation**: Counts the days remaining until the 27th of the month (inclusive).
*   **Budget Division**: Divides the entered amount by the remaining days.
*   **Modern Interface**: Dark Mode theme built with KivyMD.
*   **Cross-Platform**: Single source code for all platforms.

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

Android compilation is handled automatically via **GitHub Actions** (to avoid Buildozer issues on some Linux distros).

1.  Upload this project to a **GitHub** repository.
2.  Go to the **Actions** tab of the repository.
3.  You will see a workflow called "Build Android APK" start automatically.
4.  When finished, download the `.apk` file from the "Artifacts" section of the completed workflow.
5.  Install the APK on your smartphone.
