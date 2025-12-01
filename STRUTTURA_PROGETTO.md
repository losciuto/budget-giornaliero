# Struttura Progetto - Budget Giornaliero

## 📁 Struttura Completa

```
budget-giornaliero/
│
├── 📄 README.md                          # README principale del progetto
├── 📄 README_EN.md                       # README in inglese
├── 📄 LICENSE                            # Licenza GPL-3.0
├── 📄 GUIDA_RAPIDA_WINDOWS.txt          # ⭐ NUOVO - Guida rapida Windows
├── 📄 WINDOWS_CHECKLIST.md              # ⭐ NUOVO - Checklist Windows
├── 📄 OTTIMIZZAZIONI_WINDOWS.md         # ⭐ NUOVO - Dettagli ottimizzazioni
│
├── 📂 flutter_app/                       # Applicazione Flutter (PRINCIPALE)
│   │
│   ├── 📄 pubspec.yaml                   # Dipendenze e configurazione
│   ├── 📄 README.md                      # README Flutter app
│   ├── 📄 README_EN.md                   # README Flutter in inglese
│   ├── 📄 README_WINDOWS.md              # ⭐ NUOVO - Guida Windows dettagliata
│   ├── 📄 build_windows.bat              # ⭐ NUOVO - Script build Windows
│   │
│   ├── 📂 lib/                           # Codice sorgente Dart
│   │   ├── main.dart                     # ✏️ MODIFICATO - Ottimizzato Windows
│   │   └── logic.dart                    # Logica di calcolo
│   │
│   ├── 📂 assets/                        # Risorse
│   │   └── icon.png                      # Icona app
│   │
│   ├── 📂 android/                       # Configurazione Android
│   │   ├── app/
│   │   │   ├── build.gradle
│   │   │   └── src/
│   │   └── ...
│   │
│   ├── 📂 linux/                         # Configurazione Linux
│   │   ├── CMakeLists.txt
│   │   ├── flutter/
│   │   └── ...
│   │
│   ├── 📂 windows/                       # ⭐ NUOVO - Configurazione Windows
│   │   ├── CMakeLists.txt                # Build configuration
│   │   ├── flutter/
│   │   │   └── CMakeLists.txt
│   │   └── runner/
│   │       ├── CMakeLists.txt
│   │       ├── main.cpp                  # Entry point Windows
│   │       ├── flutter_window.cpp
│   │       ├── flutter_window.h
│   │       ├── win32_window.cpp
│   │       ├── win32_window.h
│   │       ├── utils.cpp
│   │       ├── utils.h
│   │       ├── Runner.rc
│   │       ├── runner.exe.manifest
│   │       ├── resource.h
│   │       └── resources/
│   │           └── app_icon.ico          # Icona Windows
│   │
│   ├── 📂 test/                          # Test unitari
│   │   └── widget_test.dart
│   │
│   └── 📂 build/                         # ⚠️ Generato - NON copiare
│       └── windows/
│           └── x64/
│               └── runner/
│                   └── Release/          # Eseguibile finale qui
│                       ├── budget_giornaliero.exe
│                       ├── flutter_windows.dll
│                       └── data/
│
├── 📂 native_app/                        # Versione legacy Python/Kivy
│   ├── main.py
│   ├── requirements.txt
│   └── ...
│
└── 📂 flutter_sdk/                       # SDK Flutter locale (opzionale)
    └── ...
```

## 🎯 File Chiave per Windows

### File da Portare su Windows

```
✅ NECESSARI:
flutter_app/
├── lib/                    # Tutto il codice
├── windows/                # Configurazione Windows (NUOVO)
├── assets/                 # Risorse
├── pubspec.yaml           # Dipendenze
├── pubspec.lock           # Versioni
├── README_WINDOWS.md      # Guida (NUOVO)
└── build_windows.bat      # Script (NUOVO)

❌ NON NECESSARI (verranno rigenerati):
flutter_app/
├── build/
├── .dart_tool/
├── .flutter-plugins
└── .flutter-plugins-dependencies
```

### Documentazione Windows

```
📚 Livello Progetto:
├── GUIDA_RAPIDA_WINDOWS.txt      # Consultazione rapida
├── WINDOWS_CHECKLIST.md          # Checklist completa
└── OTTIMIZZAZIONI_WINDOWS.md     # Dettagli tecnici

📚 Livello Flutter App:
└── flutter_app/
    └── README_WINDOWS.md         # Guida dettagliata compilazione
```

## 🔄 Modifiche Effettuate

### File Nuovi (⭐)

1. **`windows/`** - Intera cartella con configurazione Windows
2. **`README_WINDOWS.md`** - Guida compilazione Windows
3. **`build_windows.bat`** - Script build automatico
4. **`GUIDA_RAPIDA_WINDOWS.txt`** - Guida rapida
5. **`WINDOWS_CHECKLIST.md`** - Checklist dettagliata
6. **`OTTIMIZZAZIONI_WINDOWS.md`** - Riepilogo ottimizzazioni

### File Modificati (✏️)

1. **`lib/main.dart`**
   - Aggiunto controllo piattaforma per notifiche
   - UI condizionale per opzioni notifiche
   - Compatibilità multi-piattaforma

2. **`pubspec.yaml`**
   - Aggiunta dipendenza `msix` per installer Windows
   - Configurazione MSIX per pacchetti Windows

3. **`README.md`** (principale)
   - Aggiunto supporto Windows
   - Tabella piattaforme supportate
   - Link documentazione Windows

## 📊 Dimensioni

```
Cartella              Dimensione    Note
─────────────────────────────────────────────────────
lib/                  ~100 KB       Codice sorgente
windows/              ~50 KB        Config Windows
assets/               ~10 KB        Icone
build/ (Release)      ~50-80 MB     Eseguibile finale
Progetto completo     ~5-10 MB      Senza build/
```

## 🚀 Workflow Compilazione Windows

```
1. Copia progetto
   └─> flutter_app/ su Windows

2. Installa prerequisiti
   ├─> Visual Studio 2022
   ├─> Flutter SDK
   └─> Git

3. Build
   ├─> Automatico: build_windows.bat
   └─> Manuale: flutter build windows --release

4. Output
   └─> build\windows\x64\runner\Release\
       ├── budget_giornaliero.exe
       ├── flutter_windows.dll
       └── data/

5. Distribuzione
   ├─> ZIP: Comprimi cartella Release
   └─> MSIX: flutter pub run msix:create
```

## 🎨 Funzionalità per Piattaforma

```
Funzionalità          Android  Linux  Windows
─────────────────────────────────────────────
Calcolo Budget          ✅      ✅      ✅
Gestione Spese          ✅      ✅      ✅
Salvataggio Dati        ✅      ✅      ✅
Export Excel            ✅      ✅      ✅
Multilingua             ✅      ✅      ✅
Multi-valuta            ✅      ✅      ✅
Notifiche Push          ✅      ❌      ❌
Swipe to Delete         ✅      ✅      ✅
Tema Scuro              ✅      ✅      ✅
```

## 📝 Note Importanti

### Windows
- ✅ Tutte le funzionalità core disponibili
- ❌ Notifiche non supportate (limitazione piattaforma)
- ✅ Opzione notifiche nascosta automaticamente
- ✅ Export Excel in cartella Documenti
- ✅ Finestra ridimensionabile

### Distribuzione
- **Windows**: Distribuire TUTTA la cartella Release
- **Android**: APK singolo file
- **Linux**: AppImage o pacchetto .deb

### Sviluppo
- Codice sorgente identico per tutte le piattaforme
- Differenze solo in configurazione specifica
- Build separata per ogni piattaforma

## 🔗 Link Utili

- [Flutter SDK](https://flutter.dev)
- [Visual Studio 2022](https://visualstudio.microsoft.com/)
- [Git for Windows](https://git-scm.com/download/win)
- [CMake](https://cmake.org/download/)

---

**Versione**: 2.1.0 (Flutter)  
**Piattaforme**: Android, Linux, Windows  
**Autore**: Massimo Lo Sciuto  
**Data**: Dicembre 2025
