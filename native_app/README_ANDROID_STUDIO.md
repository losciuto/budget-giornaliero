# Utilizzo con Android Studio (LEGACY)

> [!WARNING]
> **Questa documentazione si riferisce alla vecchia versione Python/Kivy.**
> Per la nuova versione Flutter, apri semplicemente la cartella `flutter_app/android` in Android Studio.

# Utilizzo con Android Studio


Questo progetto supporta l'esportazione in un progetto compatibile con **Android Studio**. Questo ti permette di utilizzare l'IDE ufficiale di Android per compilare, firmare e debuggare l'applicazione, invece di affidarti esclusivamente alla riga di comando di Buildozer.

## Prerequisiti

*   **Buildozer**: Deve essere installato e configurato (vedi `README.md` principale).
*   **Android Studio**: Deve essere installato sul tuo sistema.

## Come Esportare il Progetto

1.  Apri un terminale nella cartella `native_app`.
2.  Esegui lo script di esportazione:
    ```bash
    python3 export_to_android_studio.py
    ```
    *Questo comando eseguirà buildozer per preparare i file necessari e creerà una cartella `android_studio_project`.*

## Come Aprire in Android Studio

1.  Avvia **Android Studio**.
2.  Clicca su **Open** (o **File > Open**).
3.  Naviga nella cartella del progetto e seleziona la directory `native_app/android_studio_project`.
4.  Attendi che Gradle completi la sincronizzazione (potrebbe richiedere qualche minuto la prima volta).

## Note Importanti

*   **Modifiche al Codice Python**: Se modifichi `main.py` o altri file Python/KV, **devi rieseguire lo script di esportazione**. Android Studio gestisce la compilazione Java/Kotlin, ma il codice Python viene pacchettizzato da Buildozer.
*   **Configurazione Buildozer**: Le modifiche a `buildozer.spec` (es. permessi, icone) richiedono anch'esse una nuova esportazione.
