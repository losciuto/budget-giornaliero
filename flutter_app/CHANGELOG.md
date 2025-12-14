# Changelog

## [2.5.0] - 2025-12-14

### 🏗️ Refactoring Maggiore
- **Architettura migliorata**: Ristrutturato `main.dart` (da 1391 a 1063 righe, -23.6%)
- **Service Layer**: Creati servizi dedicati per separare la logica di business dalla UI:
  - `StorageService`: Gestione centralizzata di SharedPreferences
  - `ExcelService`: Export Excel isolato e testabile
  - `NotificationService`: Notifiche cross-platform unificate
- **Widget Modulari**: Estratto `AddExpenseDialog` come widget riutilizzabile
- **Manutenibilità**: Codice più pulito, testabile e facile da mantenere

### 🔧 Miglioramenti Tecnici
- Ridotta complessità delle funzioni (da ~140 a ~30 righe max)
- Migliorata separazione delle responsabilità (Separation of Concerns)
- Introdotto pattern callback per comunicazione widget-parent
- Eliminato codice duplicato e boilerplate

---

## [2.4.0] - 2025-12-01

### ✨ Nuove Funzionalità
- **Scansione Scontrini**: OCR per estrarre importi da foto di scontrini (Android/iOS)
- **Categorie Spese**: 8 categorie predefinite con icone colorate
- **Periodi Budget**: Supporto per budget mensile, settimanale, bisettimanale, annuale
- **Suggerimenti Smart**: Analisi intelligente delle spese con consigli personalizzati
- **Ricerca e Filtri**: Ricerca avanzata per descrizione, categoria e intervallo di date
- **Statistiche Avanzate**: Grafici a torta e a barre per analisi visiva delle spese

### 🌍 Internazionalizzazione
- Supporto per 5 lingue: Italiano, Inglese, Spagnolo, Francese, Tedesco
- Supporto per 20+ valute globali

### 🔔 Notifiche
- Notifiche giornaliere su Android, Windows e Linux
- Promemoria personalizzati del budget disponibile

### 📊 Export e Backup
- Export Excel con formattazione professionale
- Sistema di backup/ripristino in formato JSON

---

## [2.0.0] - 2025-11-15

### 🎉 Versione Iniziale Flutter
- Migrazione completa da Python/Tkinter a Flutter
- Interfaccia utente moderna con Material Design 3
- Supporto multi-piattaforma (Android, Linux, Windows)
- Calcolo automatico budget giornaliero
- Gestione spese con swipe-to-delete
- Persistenza dati locale con SharedPreferences
