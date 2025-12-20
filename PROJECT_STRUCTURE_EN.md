# Project Structure - Daily Budget

## 📁 Complete Structure

```
budget-giornaliero/
│
├── 📄 README.md                          # Main project README (Italian)
├── 📄 README_EN.md                       # Main project README (English)
├── 📄 LICENSE                            # GPL-3.0 License
├── 📄 GUIDA_RAPIDA_WINDOWS.txt          # Quick Start Guide (Windows)
├── 📄 WINDOWS_CHECKLIST.md              # Windows Release Checklist
├── 📄 OTTIMIZZAZIONI_WINDOWS.md         # Windows Optimization Details
│
├── 📂 flutter_app/                       # Flutter Application (MAIN)
│   │
│   ├── 📄 pubspec.yaml                   # Dependencies and configuration
│   ├── 📄 README.md                      # Flutter app README (Italian)
│   ├── 📄 README_EN.md                   # Flutter app README (English)
│   ├── 📄 README_WINDOWS.md              # Detailed Windows Guide
│   ├── 📄 build_windows.bat              # Windows Build Script
│   │
│   ├── 📂 lib/                           # Dart Source Code
│   │   ├── main.dart                     # Main entry point (Windows Optimized)
│   │   └── logic.dart                    # Calculation logic
│   │
│   ├── 📂 assets/                        # Resources
│   │   └── icon.png                      # App icon
│   │
│   ├── 📂 android/                       # Android Configuration
│   │   ├── app/
│   │   │   ├── build.gradle
│   │   │   └── src/
│   │   └── ...
│   │
│   ├── 📂 linux/                         # Linux Configuration
│   │   ├── CMakeLists.txt
│   │   ├── flutter/
│   │   └── ...
│   │
│   ├── 📂 windows/                       # Windows Configuration
│   │   ├── CMakeLists.txt                # Build configuration
│   │   ├── flutter/
│   │   │   └── CMakeLists.txt
│   │   └── runner/
│   │       ├── CMakeLists.txt
│   │       ├── main.cpp                  # Windows entry point
│   │       ├── ...
│   │       └── resources/
│   │           └── app_icon.ico          # Windows icon
│   │
│   ├── 📂 test/                          # Unit & Widget Tests
│   │   └── widget_test.dart
│   │
│   └── 📂 build/                         # ⚠️ Generated - DO NOT COPY
│       └── windows/
│           └── x64/
│               └── runner/
│                   └── Release/          # Final executable location
│                       ├── budget_giornaliero.exe
│                       ├── flutter_windows.dll
│                       └── data/
│
├── 📂 native_app/                        # Legacy Python/Kivy Version
│   ├── main.py
│   ├── requirements.txt
│   └── ...
│
└── 📂 flutter_sdk/                       # Local Flutter SDK (optional)
    └── ...
```

## 🎯 Key Files for Windows

### Files to move to Windows

```
✅ REQUIRED:
flutter_app/
├── lib/                    # All code
├── windows/                # Windows configuration
├── assets/                 # Resources
├── pubspec.yaml           # Dependencies
├── pubspec.lock           # Versions
├── README_WINDOWS.md      # Guide
└── build_windows.bat      # Script

❌ NOT REQUIRED (will be regenerated):
flutter_app/
├── build/
├── .dart_tool/
├── .flutter-plugins
└── .flutter-plugins-dependencies
```

### Windows Documentation

```
📚 Project Level:
├── GUIDA_RAPIDA_WINDOWS.txt      # Quick reference
├── WINDOWS_CHECKLIST.md          # Complete checklist
└── OTTIMIZZAZIONI_WINDOWS.md     # Technical details

📚 Flutter App Level:
└── flutter_app/
    └── README_WINDOWS.md         # Detailed compilation guide
```

## 🔄 Changes Made

### New Files

1. **`windows/`** - Entire folder with Windows configuration
2. **`README_WINDOWS.md`** - Windows compilation guide
3. **`build_windows.bat`** - Automatic build script
4. **`GUIDA_RAPIDA_WINDOWS.txt`** - Quick guide
5. **`WINDOWS_CHECKLIST.md`** - Detailed checklist
6. **`OTTIMIZZAZIONI_WINDOWS.md`** - Optimization summary

### Modified Files

1. **`lib/main.dart`**
   - Added platform check for notifications
   - Conditional UI for notification options
   - Multi-platform compatibility

2. **`pubspec.yaml`**
   - Added `msix` dependency for Windows installer
   - MSIX configuration for Windows packages

3. **`README.md`** (main)
   - Added Windows support
   - Supported platforms table
   - Windows documentation links

## 📊 Dimensions

```
Folder                Size          Notes
─────────────────────────────────────────────────────
lib/                  ~100 KB       Source code
windows/              ~50 KB        Windows config
assets/               ~10 KB        Icons
build/ (Release)      ~50-80 MB     Final executable
Complete project      ~5-10 MB      Without build/
```

## 🚀 Windows Compilation Workflow

```
1. Copy project
   └─> flutter_app/ to Windows

2. Install prerequisites
   ├─> Visual Studio 2022
   ├─> Flutter SDK
   └─> Git

3. Build
   ├─> Automatic: build_windows.bat
   └─> Manual: flutter build windows --release

4. Output
   └─> build\windows\x64\runner\Release\
       ├── budget_giornaliero.exe
       ├── flutter_windows.dll
       └── data/

5. Distribution
   ├─> ZIP: Compress Release folder
   └─> MSIX: flutter pub run msix:create
```

## 🎨 Features by Platform

```
Feature               Android  Linux  Windows
─────────────────────────────────────────────
Budget Calculation      ✅      ✅      ✅
Expense Management      ✅      ✅      ✅
Data Saving             ✅      ✅      ✅
Excel Export            ✅      ✅      ✅
Multilingual            ✅      ✅      ✅
Multi-currency          ✅      ✅      ✅
Push Notifications      ✅      ❌      ❌
Swipe to Delete         ✅      ✅      ✅
Dark Theme              ✅      ✅      ✅
```

## 📝 Important Notes

### Windows
- ✅ All core features available
- ❌ Notifications not supported (platform limitation)
- ✅ Notification option automatically hidden
- ✅ Excel export in Documents folder
- ✅ Resizable window

---

**Version**: 2.6.1 (Flutter)  
**Platforms**: Android, Linux, Windows  
**Author**: Massimo Lo Sciuto  
**Date**: December 2025
