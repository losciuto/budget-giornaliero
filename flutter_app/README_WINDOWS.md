# Compilazione per Windows

## Prerequisiti

Per compilare l'applicazione Budget Giornaliero su Windows, hai bisogno di:

1. **Visual Studio 2022** (Community Edition è sufficiente)
   - Durante l'installazione, seleziona "Desktop development with C++"
   - Componenti richiesti:
     - MSVC v142 o superiore
     - Windows 10 SDK (10.0.17763.0 o superiore)
     - C++ CMake tools for Windows

2. **Flutter SDK**
   - Scarica da: https://docs.flutter.dev/get-started/install/windows
   - Estrai in una cartella (es: `C:\flutter`)
   - Aggiungi `C:\flutter\bin` al PATH di sistema

3. **Git for Windows**
   - Scarica da: https://git-scm.com/download/win

## Verifica dell'ambiente

Dopo aver installato i prerequisiti, apri PowerShell o Command Prompt e verifica:

```bash
flutter doctor
```

Dovresti vedere qualcosa come:
```
[✓] Flutter (Channel stable, 3.x.x, on Microsoft Windows...)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Visual Studio - develop Windows apps (Visual Studio Community 2022...)
[✓] Connected device (1 available)
[✓] Network resources
```

## Compilazione

### 1. Preparazione

Naviga nella cartella del progetto:
```bash
cd C:\percorso\verso\budget-giornaliero\flutter_app
```

### 2. Ottieni le dipendenze

```bash
flutter pub get
```

### 3. Build Release

Per creare un eseguibile Windows ottimizzato:

```bash
flutter build windows --release
```

L'eseguibile verrà creato in:
```
build\windows\x64\runner\Release\
```

### 4. Build Debug (per sviluppo)

Se vuoi testare durante lo sviluppo:

```bash
flutter run -d windows
```

## File da portare su Windows

Per compilare l'applicazione su un PC Windows, devi portare:

1. **Cartella completa del progetto Flutter**:
   ```
   budget-giornaliero/flutter_app/
   ```
   
   Questa include:
   - `lib/` - Codice sorgente Dart
   - `windows/` - Configurazione specifica per Windows
   - `assets/` - Risorse (icone, ecc.)
   - `pubspec.yaml` - Dipendenze del progetto
   - Tutti gli altri file di configurazione

2. **NON serve portare**:
   - `build/` - Verrà rigenerata
   - `.dart_tool/` - Verrà rigenerata
   - `android/` e `linux/` - Non necessari per Windows (ma non fanno male)

## Distribuzione

Dopo la compilazione, per distribuire l'applicazione:

1. Copia l'intera cartella `build\windows\x64\runner\Release\`
2. Questa cartella contiene:
   - `budget_giornaliero.exe` - L'eseguibile principale
   - `flutter_windows.dll` - Libreria Flutter
   - `data/` - Risorse dell'app
   - Altri file DLL necessari

3. **IMPORTANTE**: Devi distribuire TUTTA la cartella Release, non solo l'exe!

## Creazione di un Installer (Opzionale)

Per creare un installer professionale, puoi usare:

### Opzione 1: Inno Setup (Gratuito)

1. Scarica Inno Setup: https://jrsoftware.org/isinfo.php
2. Crea uno script `.iss` per il tuo progetto
3. Compila l'installer

### Opzione 2: MSIX (Microsoft Store)

```bash
flutter pub add msix
flutter pub get
flutter build windows
flutter pub run msix:create
```

Questo crea un pacchetto MSIX installabile.

## Ottimizzazioni Specifiche per Windows

L'applicazione è stata ottimizzata per Windows:

- ✅ Notifiche locali (tramite local_notifier)
- ✅ Ricerca e Filtri avanzati per spese
- ✅ Statistiche dettagliate con grafici
- ✅ Backup e Ripristino completo (JSON)
- ✅ Suggerimenti Smart basati sui pattern di spesa
- ✅ Salvataggio dati funziona con shared_preferences
- ✅ Export Excel completamente funzionale
- ✅ Selezione data e interfaccia grafica native Windows
- ✅ Supporto per temi scuri/chiari di Windows
- ✅ Multilingua (5 lingue: IT, EN, ES, FR, DE)
- ✅ Multi-valuta (20+ valute)

## Risoluzione Problemi

### Errore: "Visual Studio not found"
- Assicurati di aver installato Visual Studio 2022 con "Desktop development with C++"
- Riavvia il terminale dopo l'installazione

### Errore: "CMake not found"
- Installa CMake tramite Visual Studio Installer
- Oppure scarica da: https://cmake.org/download/

### Errore durante flutter pub get
- Verifica la connessione internet
- Prova: `flutter pub cache repair`

### L'app non si avvia
- Assicurati di distribuire TUTTA la cartella Release
- Verifica che tutte le DLL siano presenti

## Note sulla Versione

Versione: 2.7.1 (Flutter) - Gennaio 2026
- **Refactoring architetturale**: Codice più modulare e manutenibile
- Supporto completo per Windows 10/11
- Interfaccia ottimizzata per desktop
- Notifiche locali tramite local_notifier
- Tutte le funzionalità avanzate disponibili
- Vedi [CHANGELOG.md](CHANGELOG.md) per dettagli completi

## Supporto

Per problemi o domande:
- Autore: [losciuto](https://github.com/losciuto/budget-giornaliero)
- Repository: https://github.com/losciuto/budget-giornaliero
