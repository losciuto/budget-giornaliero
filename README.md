# Budget Giornaliero

Un'applicazione cross-platform (Android, Linux, Windows) per calcolare il budget giornaliero disponibile fino a una data specifica del mese corrente.
![Version](https://img.shields.io/badge/version-2.5.0-blue.svg)

**Versione Corrente:** 2.5.0 (Flutter) - Refactoring Architetturale

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
*   **Multilingua**: Supporto completo per Italiano, Inglese, Spagnolo, Francese e Tedesco.
*   **Multi-valuta**: Supporto per oltre 20 valute mondiali.
*   **Ricerca e Filtri**: Ricerca avanzata per descrizione, categoria e data.
*   **Statistiche**: Grafici a torta e a barre per analizzare le spese.
*   **Backup e Ripristino**: Salvataggio e caricamento dati in formato JSON.
*   **Suggerimenti Smart**: Analisi intelligente delle spese con consigli personalizzati.
*   **Design Moderno**: Material Design 3 con supporto tema scuro/chiaro.
*   **Cross-Platform**: Supporto nativo per Android, Linux Desktop e **Windows**.

## 🌍 Lingue / Languages

*   🇮🇹 [Italiano](README.md)
*   🇬🇧 [English](README_EN.md) (To be created)
*   🇪🇸 [Español](README_ES.md)
*   🇫🇷 [Français](README_FR.md)
*   🇩🇪 [Deutsch](README_DE.md)

### Piattaforme Supportate

| Piattaforma | Stato | Note |
|-------------|-------|------|
| 🤖 Android | ✅ Completo | Tutte le funzionalità incluse notifiche |
| 🐧 Linux | ✅ Completo | Desktop nativo con notifiche locali |
| 🪟 Windows | ✅ Completo | Desktop nativo con notifiche locali |

### Documentazione Specifica

- **Windows**: Vedi [GUIDA_RAPIDA_WINDOWS.txt](GUIDA_RAPIDA_WINDOWS.txt) per istruzioni rapide
- **Windows (Dettagliata)**: Vedi [flutter_app/README_WINDOWS.md](flutter_app/README_WINDOWS.md)
- **Checklist Windows**: Vedi [WINDOWS_CHECKLIST.md](WINDOWS_CHECKLIST.md)
- **Ottimizzazioni**: Vedi [OTTIMIZZAZIONI_WINDOWS.md](OTTIMIZZAZIONI_WINDOWS.md)

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
*   **Autore**: [losciuto](https://github.com/losciuto/budget-giornaliero)
*   **Supporto**: Antigravity
*   **Sviluppo**: Gemini 3 Pro
