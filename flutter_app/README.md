# Budget Giornaliero - Flutter App

[English version](README_EN.md)

Applicazione moderna per la gestione del budget giornaliero, sviluppata interamente in Flutter.

## 📱 Funzionalità

- **Calcolo Budget Giornaliero**: Calcola automaticamente quanto puoi spendere al giorno in base al budget totale e ai giorni rimanenti
- **Gestione Spese**: Aggiungi, visualizza ed elimina spese con swipe-to-delete
- **Saldo Progressivo**: Visualizza il saldo rimanente dopo ogni spesa
- **Multilingua**: Supporto per Italiano e Inglese
- **Multi-valuta**: Supporto per 20+ valute (EUR, USD, GBP, JPY, CHF, CAD, AUD, CNY, INR, BRL, RUB, KRW, MXN, ZAR, SEK, NOK, DKK, PLN, TRY, AED)
- **Notifiche Giornaliere**: Promemoria giornalieri del budget disponibile (solo Android)
- **Esportazione Excel**: Esporta il riepilogo budget e le spese in formato Excel con formattazione professionale
- **Cancellazione Rapida**: Elimina tutte le spese con un solo tap
- **Cross-platform**: Disponibile per Android e Linux Desktop

## 🏗️ Struttura del Progetto

- `lib/main.dart`: Punto di ingresso dell'applicazione e interfaccia utente (UI)
- `lib/logic.dart`: Logica di business (calcolo giorni e budget)
- `test/`: Unit test e Widget test
- `android/`: Progetto nativo Android (configurabile in Android Studio)
- `linux/`: Configurazione per build Linux Desktop
- `assets/`: Risorse dell'applicazione (icone)

## 🚀 Per Iniziare

### Prerequisiti
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installato e configurato nel PATH
- Un editor di codice (VS Code o Android Studio) con i plugin Flutter/Dart installati
- **Android Build**: Richiede NDK versione 27.0.12077973 o superiore e supporto Java 8 core library desugaring (già configurato in `build.gradle`)

### Esecuzione
1. Ottieni le dipendenze:
   ```bash
   flutter pub get
   ```
2. Avvia l'app (seleziona il dispositivo target se necessario):
   ```bash
   flutter run
   ```

### Testing
Per verificare che tutto funzioni correttamente:
```bash
flutter test
```

## 🔧 Android Studio
Per modifiche specifiche alla parte Android (es. `AndroidManifest.xml`, `build.gradle`):
1. Apri Android Studio
2. Seleziona **Open**
3. Scegli la cartella `android` all'interno di `flutter_app` (NON la cartella `flutter_app` principale)

## 📦 Build per il Rilascio

### Android (APK)
```bash
flutter build apk --release
```
L'APK sarà generato in `build/app/outputs/flutter-apk/app-release.apk`.

### Linux
```bash
flutter build linux --release
```
L'eseguibile sarà in `build/linux/x64/release/bundle/budget_giornaliero`.

## 🎨 Personalizzazione Icona

Per modificare l'icona dell'app:
1. Sostituisci `assets/icon.png` con la tua icona (1024x1024 px consigliato)
2. Esegui:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

## 📚 Dipendenze Principali

- `flutter_localizations`: Internazionalizzazione
- `google_fonts`: Font personalizzati
- `shared_preferences`: Persistenza dati locale
- `flutter_local_notifications`: Notifiche push
- `excel`: Esportazione file Excel
- `path_provider`: Accesso al filesystem
- `intl`: Formattazione date e valute

## 👨‍💻 Autore

**Massimo Lo Sciuto**

Sviluppato con il supporto di Antigravity e Gemini 2.0 Pro

## 📄 Versione

**2.1.0** (Flutter)
