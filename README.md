# Budget Giornaliero

Un'applicazione cross-platform (Android, Linux, Windows) per calcolare il budget giornaliero disponibile fino a una data specifica del mese corrente.

**Versione Corrente:** 2.1.0 (Flutter)

## 🚀 Nuova Versione Flutter

Il progetto è stato completamente riscritto in **Flutter** per garantire migliori prestazioni e un'esperienza utente moderna.
Il codice sorgente si trova nella cartella `flutter_app/`.

### Funzionalità Principali
*   **Calcolo Automatico**: Giorni mancanti e budget giornaliero.
*   **Data Configurabile**: Selettore data intuitivo.
*   **Gestione Spese**: Aggiunta spese con swipe-to-delete.
*   **Notifiche**: Promemoria giornaliero del budget residuo.
*   **Export Excel**: Esportazione report spese in formato .xlsx.
*   **Internazionalizzazione**: Supporto italiano/inglese.
*   **Valute Personalizzabili**: Supporto per oltre 20 valute (EUR, USD, GBP, ecc.) selezionabili dalle impostazioni.
*   **Design Moderno**: Material Design 3 con supporto tema scuro/chiaro.
*   **Cross-Platform**: Supporto nativo per Android e Linux Desktop.

### Guida Rapida
Per iniziare a sviluppare o eseguire la versione Flutter:

1.  Assicurati di avere installato il [Flutter SDK](https://flutter.dev).
2.  Entra nella cartella dell'app:
    ```bash
    cd flutter_app
    ```
3.  Esegui l'app:
    ```bash
    flutter run
    ```

Vedi il [README di Flutter](flutter_app/README.md) per istruzioni dettagliate su test, build e configurazione Android Studio.

---

## 🐍 Versione Legacy (Python/Kivy)

La versione originale scritta in Python e Kivy è ancora disponibile nella cartella `native_app/`, ma non è più attivamente mantenuta.

### Istruzioni Legacy (Linux)
1.  Crea un virtual environment: `python3 -m venv venv`
2.  Attiva: `source venv/bin/activate`
3.  Installa dipendenze: `pip install -r native_app/requirements.txt`
4.  Esegui: `python native_app/main.py`

Per dettagli sulla vecchia compilazione Android con Buildozer, vedi i file nella cartella `native_app/`.

## Crediti
*   **Autore**: Massimo Lo Sciuto
*   **Supporto**: Antigravity
*   **Sviluppo**: Gemini 3 Pro
