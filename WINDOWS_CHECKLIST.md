# Checklist: Portare il Progetto su Windows

## 📦 File e Cartelle da Portare

### ✅ NECESSARI (da copiare su Windows)

```
budget-giornaliero/
└── flutter_app/
    ├── lib/                          # Codice sorgente Dart
    ├── windows/                      # Configurazione Windows (appena creata)
    ├── assets/                       # Icone e risorse
    ├── pubspec.yaml                  # Dipendenze
    ├── pubspec.lock                  # Versioni esatte delle dipendenze
    ├── analysis_options.yaml         # Regole di analisi
    ├── README_WINDOWS.md             # Istruzioni Windows
    ├── build_windows.bat             # Script di build automatico
    └── .metadata                     # Metadati Flutter
```

### ❌ NON NECESSARI (verranno rigenerati)

```
flutter_app/
├── build/                 # Verrà rigenerata durante la compilazione
├── .dart_tool/           # Verrà rigenerata
├── .flutter-plugins      # Verrà rigenerata
└── .flutter-plugins-dependencies  # Verrà rigenerata
```

### ⚠️ OPZIONALI (non necessari per Windows ma non fanno male)

```
flutter_app/
├── android/              # Solo per build Android
├── linux/                # Solo per build Linux
└── test/                 # Test unitari
```

## 🔧 Prerequisiti da Installare su Windows

### 1. Visual Studio 2022 Community Edition
- **Download**: https://visualstudio.microsoft.com/downloads/
- **Componenti richiesti durante l'installazione**:
  - ✅ Desktop development with C++
  - ✅ MSVC v142 o superiore
  - ✅ Windows 10 SDK (10.0.17763.0 o superiore)
  - ✅ C++ CMake tools for Windows

### 2. Flutter SDK
- **Download**: https://docs.flutter.dev/get-started/install/windows
- **Installazione**:
  1. Scarica il file ZIP
  2. Estrai in `C:\flutter` (o altra posizione)
  3. Aggiungi `C:\flutter\bin` al PATH di sistema
  4. Apri un nuovo terminale e verifica: `flutter --version`

### 3. Git for Windows
- **Download**: https://git-scm.com/download/win
- Necessario per Flutter

## 📋 Procedura Passo-Passo

### Metodo 1: Build Automatica (Consigliato)

1. **Copia il progetto** su Windows nella posizione desiderata
   ```
   Esempio: C:\Projects\budget-giornaliero\flutter_app\
   ```

2. **Doppio click** su `build_windows.bat`
   - Lo script farà tutto automaticamente
   - Al termine aprirà la cartella con l'eseguibile

### Metodo 2: Build Manuale

1. **Apri PowerShell o Command Prompt**

2. **Naviga nella cartella del progetto**
   ```bash
   cd C:\Projects\budget-giornaliero\flutter_app
   ```

3. **Verifica l'ambiente**
   ```bash
   flutter doctor
   ```
   Tutti i check devono essere verdi (✓)

4. **Scarica le dipendenze**
   ```bash
   flutter pub get
   ```

5. **Compila per Windows**
   ```bash
   flutter build windows --release
   ```

6. **Trova l'eseguibile**
   ```
   build\windows\x64\runner\Release\budget_giornaliero.exe
   ```

## 📦 Distribuzione dell'App

### File da Distribuire

**IMPORTANTE**: Non distribuire solo l'EXE, ma TUTTA la cartella Release!

```
build\windows\x64\runner\Release\
├── budget_giornaliero.exe    # Eseguibile principale
├── flutter_windows.dll       # Libreria Flutter
├── data\                     # Risorse dell'app
│   └── icudtl.dat
└── [altre DLL necessarie]
```

### Opzioni di Distribuzione

#### Opzione A: Cartella ZIP (Semplice)
1. Comprimi tutta la cartella `Release` in un file ZIP
2. L'utente estrae e lancia l'exe

#### Opzione B: Installer MSIX (Professionale)
```bash
flutter pub run msix:create
```
Crea un pacchetto installabile `.msix` in `build\windows\x64\runner\Release\`

## 🔍 Modifiche Effettuate per Windows

### Codice Ottimizzato

1. **Notifiche Disabilitate su Desktop**
   - Le notifiche funzionano solo su Android/iOS
   - Su Windows l'opzione è nascosta automaticamente
   - Nessun errore durante l'esecuzione

2. **Gestione Piattaforme**
   ```dart
   // Controllo piattaforma per notifiche
   if (Platform.isAndroid || Platform.isIOS) {
     // Mostra opzione notifiche
   }
   ```

3. **Tutte le Altre Funzionalità Funzionanti**
   - ✅ Salvataggio dati (SharedPreferences)
   - ✅ Export Excel
   - ✅ Selezione date
   - ✅ Calcoli budget
   - ✅ Gestione spese
   - ✅ Multilingua (IT/EN)
   - ✅ Multi-valuta

### File Aggiunti

1. **`windows/`** - Cartella con configurazione Windows
2. **`README_WINDOWS.md`** - Guida completa Windows
3. **`build_windows.bat`** - Script build automatico
4. **Configurazione MSIX** in `pubspec.yaml`

## ⚠️ Problemi Comuni e Soluzioni

### "Visual Studio not found"
**Soluzione**: Installa Visual Studio 2022 con "Desktop development with C++"

### "CMake not found"
**Soluzione**: Installa CMake tramite Visual Studio Installer

### "Flutter command not found"
**Soluzione**: Aggiungi Flutter al PATH e riavvia il terminale

### L'app non si avvia dopo la compilazione
**Soluzione**: Assicurati di distribuire TUTTA la cartella Release, non solo l'exe

### Errore durante flutter pub get
**Soluzione**: 
```bash
flutter pub cache repair
flutter pub get
```

## 📊 Dimensioni Stimate

- **Progetto sorgente**: ~5-10 MB
- **Build completa**: ~50-80 MB
- **Installer MSIX**: ~30-50 MB

## ✅ Verifica Finale

Prima di distribuire, testa su Windows:

- [ ] L'app si avvia correttamente
- [ ] Puoi inserire un budget
- [ ] Puoi aggiungere spese
- [ ] Il calcolo del budget giornaliero funziona
- [ ] L'export Excel funziona
- [ ] Il cambio lingua funziona
- [ ] Il cambio valuta funziona
- [ ] I dati vengono salvati e ripristinati

## 📞 Supporto

- **Autore**: Massimo Lo Sciuto
- **Versione**: 2.1.0 (Flutter)
- **Piattaforme**: Android, Linux, Windows

---

**Ultimo aggiornamento**: Dicembre 2025
