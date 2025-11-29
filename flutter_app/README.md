# Budget Giornaliero - Flutter App

Questa è la versione moderna dell'applicazione Budget Giornaliero, riscritta interamente in Flutter.

## Struttura del Progetto

*   `lib/main.dart`: Punto di ingresso dell'applicazione e interfaccia utente (UI).
*   `lib/logic.dart`: Logica di business (calcolo giorni e budget).
*   `test/`: Unit test e Widget test.
*   `android/`: Progetto nativo Android (configurabile in Android Studio).
*   `linux/`: Configurazione per build Linux Desktop.

## Per Iniziare

### Prerequisiti
*   [Flutter SDK](https://flutter.dev/docs/get-started/install) installato e configurato nel PATH.
*   Un editor di codice (VS Code o Android Studio) con i plugin Flutter/Dart installati.

### Esecuzione
1.  Ottieni le dipendenze:
    ```bash
    flutter pub get
    ```
2.  Avvia l'app (seleziona il dispositivo target se necessario):
    ```bash
    flutter run
    ```

### Testing
Per verificare che tutto funzioni correttamente:
```bash
flutter test
```

## Android Studio
Per modifiche specifiche alla parte Android (es. `AndroidManifest.xml`, `build.gradle`):
1.  Apri Android Studio.
2.  Seleziona **Open**.
3.  Scegli la cartella `android` all'interno di `flutter_app` (NON la cartella `flutter_app` principale).

## Build per il Rilascio

### Android (APK)
```bash
flutter build apk --release
```
L'APK sarà generato in `build/app/outputs/flutter-apk/app-release.apk`.

### Linux
```bash
flutter build linux --release
```
L'eseguibile sarà in `build/linux/x64/release/bundle/`.
