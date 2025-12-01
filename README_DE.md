# 💰 Tagesbudget (Budget Giornaliero)

Eine einfache und leistungsstarke Flutter-App zur Verwaltung Ihres monatlichen Budgets und zur Kontrolle der täglichen Ausgaben.

![Version](https://img.shields.io/badge/version-2.2.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B.svg)
![Plattform](https://img.shields.io/badge/platform-Android%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)

## ✨ Hauptfunktionen

*   **📅 Automatische Berechnung**: Berechnet, wie viel Sie heute ausgeben können, basierend auf Ihrem Monatsbudget und den verbleibenden Tagen.
*   **🏷️ Ausgabenkategorien**: Organisieren Sie Ihre Ausgaben mit Symbolen und Farben (Essen, Transport, Freizeit usw.).
*   **📊 Grafische Statistiken**: Visualisieren Sie Ihre Ausgaben mit interaktiven Kreis- und Balkendiagrammen.
*   **💾 Vollständiges Backup**: Exportieren und importieren Sie alle Ihre Daten (JSON), um nichts zu verlieren.
*   **📱 Multiplattform**: Funktioniert perfekt auf Android, Linux und Windows.
*   **🔔 Tägliche Benachrichtigungen**: Erhalten Sie eine Erinnerung mit Ihrem verbleibenden Budget (nur Android).
*   **🌍 Mehrsprachig**: Verfügbar in Italienisch, Englisch, Spanisch, Französisch und Deutsch.
*   **💱 Mehrere Währungen**: Unterstützung für über 20 Währungen (EUR, USD, GBP, JPY usw.).
*   **📤 Excel-Export**: Exportieren Sie Ihren Ausgabenverlauf in eine Excel-Datei (.xlsx).
*   **🌙 Dunkelmodus**: Saubere und moderne Benutzeroberfläche, die Ihr Systemthema respektiert.

## 🚀 Installation

### Android
Laden Sie die `.apk`-Datei aus dem Ordner `build/app/outputs/flutter-apk/` herunter und installieren Sie sie.

### Windows
1.  Laden Sie den Quellcode herunter.
2.  Führen Sie `build_windows.bat` zum Kompilieren aus.
3.  Die ausführbare Datei befindet sich in `build/windows/runner/Release/`.

### Linux
1.  Stellen Sie sicher, dass Flutter installiert ist.
2.  Führen Sie `flutter build linux --release` aus.
3.  Starten Sie die App aus `build/linux/x64/release/bundle/`.

## 📖 Wie benutzt man

1.  **Ersteinrichtung**: Legen Sie Ihr Gesamtbudget und das Monatsende fest.
2.  **Ausgaben hinzufügen**: Tippen Sie auf die Schaltfläche `+`, wählen Sie eine Kategorie und geben Sie den Betrag ein.
3.  **Überwachen**: Beobachten Sie, wie sich Ihr verfügbares Tagesbudget aktualisiert.
4.  **Statistiken**: Tippen Sie auf das Symbol 📊, um detaillierte Diagramme anzuzeigen.
5.  **Sicherung**: Tippen Sie auf das Symbol 💾, um Ihre Daten zu speichern.

## 🛠️ Technologien

*   **Flutter & Dart**: Hauptframework.
*   **shared_preferences**: Lokale Datenspeicherung.
*   **fl_chart**: Diagramme und Statistiken.
*   **file_picker**: Dateiauswahl.
*   **flutter_local_notifications**: Lokale Benachrichtigungen.
*   **excel**: Datenexport.

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz.

---
**Autor**: Massimo Lo Sciuto
**Entwickelt mit**: Antigravity (Gemini 3 Pro)
