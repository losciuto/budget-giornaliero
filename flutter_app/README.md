# Budget Giornaliero - Flutter App

[English version](README_EN.md)

Applicazione moderna per la gestione del budget giornaliero, sviluppata interamente in Flutter.

## 📱 Funzionalità

- **Calcolo Budget Giornaliero**: Calcola automaticamente quanto puoi spendere al giorno in base al budget totale e ai giorni rimanenti
- **Gestione Spese**: Aggiungi, visualizza ed elimina spese con swipe-to-delete
- **Saldo Progressivo**: Visualizza il saldo rimanente dopo ogni spesa
- **Multilingua**: Supporto per 5 lingue (Italiano, Inglese, Spagnolo, Francese, Tedesco)
- **Multi-valuta**: Supporto per 20+ valute (EUR, USD, GBP, JPY, CHF, CAD, AUD, CNY, INR, BRL, RUB, KRW, MXN, ZAR, SEK, NOK, DKK, PLN, TRY, AED)
- **Notifiche Giornaliere**: Promemoria giornalieri del budget disponibile (Android, Windows, Linux)
- **Ricerca e Filtri**: Ricerca avanzata per descrizione, categoria e data
- **Statistiche**: Grafici a torta e a barre per analizzare le spese
- **Backup e Ripristino**: Salvataggio e caricamento dati in formato JSON
- **Suggerimenti Smart**: Analisi intelligente delle spese con consigli personalizzati
- **Esportazione Excel**: Esporta il riepilogo budget e le spese in formato Excel con formattazione professionale
- **Cancellazione Rapida**: Elimina tutte le spese con un solo tap
- **Cross-platform**: Disponibile per Android, Linux Desktop e Windows

## 🏗️ Struttura del Progetto

### Architettura (v2.5.0+)
L'applicazione segue un'architettura a layer con separazione delle responsabilità:

- `lib/main.dart`: Punto di ingresso e interfaccia utente principale
- `lib/services/`: Service layer per la logica di business
  - `storage_service.dart`: Gestione persistenza dati (SharedPreferences)
  - `excel_service.dart`: Export in formato Excel
  - `notification_service.dart`: Notifiche cross-platform
- `lib/widgets/`: Widget riutilizzabili
  - `add_expense_dialog.dart`: Dialog per aggiunta spese
- `lib/logic.dart`: Logica di calcolo budget e modelli dati
- `lib/statistics_screen.dart`: Schermata statistiche
- `lib/search_filter_screen.dart`: Ricerca e filtri
- `lib/smart_features.dart`: Suggerimenti intelligenti
- `lib/backup_manager.dart`: Gestione backup/ripristino
- `lib/app_strings.dart`: Stringhe localizzate
- `test/`: Unit test e Widget test
- `android/`: Progetto nativo Android
- `linux/`: Configurazione build Linux
- `windows/`: Configurazione build Windows
- `assets/`: Risorse (icone)

> 📖 Per dettagli sul refactoring v2.5.0, vedi [REFACTORING.md](REFACTORING.md)

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

**[losciuto](https://github.com/losciuto/budget-giornaliero)**

Sviluppato con il supporto di Antigravity e Gemini 3 Pro

## 📄 Versione

**2.7.1** - Resoconti Periodici (Gennaio 2026)

### Novità v2.7.0

- **Resoconti Periodici**: Nuova dashboard completa per report giornalieri, settimanali, mensili e annuali
- **Grafici Interattivi**: Grafici a barre per una visualizzazione immediata dei trend di spesa
- **Navigazione Temporale**: Sfoglia facilmente i periodi passati e futuri (giorni, settimane, mesi, anni)

### Novità v2.6.2

- **Nuove Categorie**: Aggiunte categorie per "Spese per Mara", "Contante" e "Medicinali"

### Novità v2.6.1

- **Documentazione Internazionale**: Tradotta tutta la documentazione tecnica principale in inglese
- **Consistenza Versioni**: Allineamento delle versioni in tutti i file di rilascio

### Novità v2.6.0

- **Cartella Backup Android**: I backup ora vengono salvati nella cartella Download pubblica per maggiore accessibilità
- **Permessi Ottimizzati**: Gestione automatica dei permessi storage per tutte le versioni Android

### Novità v2.5.0
- 🏗️ Architettura migliorata con service layer
- 📦 Codice più modulare e manutenibile (-23.6% complessità)
- 🧪 Migliore testabilità dei componenti
- 📚 Vedi [CHANGELOG.md](CHANGELOG.md) per dettagli completi
