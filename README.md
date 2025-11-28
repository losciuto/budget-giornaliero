# Budget Giornaliero

Un'applicazione cross-platform (Linux, Windows, Android) per calcolare il budget giornaliero disponibile fino a una data specifica del mese corrente.

**Versione:** 1.1.1

## Funzionalità
*   **Calcolo Automatico**: Conta i giorni mancanti alla data obiettivo (incluso).
*   **Data Configurabile**: Seleziona la data di fine budget tramite un comodo calendario (DatePicker).
*   **Divisione Budget**: Divide l'importo inserito per i giorni rimanenti.
*   **Interfaccia Moderna**: Tema scuro (Dark Mode) realizzato con KivyMD.
*   **Info e Crediti**: Finestra dedicata con i dettagli del progetto.
*   **Cross-Platform**: Unico codice sorgente per tutte le piattaforme.

## Crediti
*   **Autore**: Massimo Lo Sciuto
*   **Supporto**: Antigravity
*   **Sviluppo**: Gemini 3 Pro

## Struttura del Progetto
Il codice sorgente si trova nella cartella `native_app/`.

## Istruzioni per l'Uso e Compilazione

### 🐧 Linux (Mint, Ubuntu, Debian)

Per eseguire l'applicazione senza "sporcare" il sistema, si consiglia l'uso di un ambiente virtuale (`venv`).

1.  **Installa le dipendenze di sistema:**
    ```bash
    sudo apt update
    sudo apt install python3-pip python3-venv libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev xclip xsel
    ```

2.  **Crea e attiva l'ambiente virtuale** (nella cartella del progetto):
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    ```

3.  **Installa le librerie Python:**
    ```bash
    pip install -r native_app/requirements.txt
    ```

4.  **Avvia l'App:**
    ```bash
    python native_app/main.py
    ```

5.  **Crea Eseguibile (Opzionale):**
    ```bash
    pip install "pyinstaller<6.0"
    pyinstaller --onefile --windowed --name="BudgetGiornaliero" native_app/main.py
    ```

---

### 🪟 Windows

Per creare un file `.exe` funzionante, è necessario eseguire questi passaggi **su un PC Windows**.

1.  Installa [Python](https://www.python.org/) (seleziona "Add to PATH" durante l'installazione).
2.  Apri il terminale (PowerShell o CMD) nella cartella del progetto.
3.  Installa le dipendenze:
    ```powershell
    pip install -r native_app/requirements.txt
    pip install "pyinstaller<6.0"
    ```
4.  Crea l'eseguibile:
    ```powershell
    pyinstaller --onefile --windowed --name="BudgetGiornaliero" native_app/main.py
    ```
5.  Troverai il file `BudgetGiornaliero.exe` nella cartella `dist`.

---

### 🤖 Android

Per compilare l'APK Android, è necessario usare **Buildozer** su un sistema **Linux** (o WSL su Windows).

1.  **Installa le dipendenze di sistema** (Ubuntu/Debian):
    ```bash
    sudo apt update
    sudo apt install -y git zip unzip openjdk-17-jdk python3-pip autoconf libtool pkg-config zlib1g-dev libncurses5-dev libncursesw5-dev libtinfo5 cmake libffi-dev libssl-dev
    ```

2.  **Installa Buildozer**:
    ```bash
    pip3 install --user buildozer
    ```

3.  **Compila l'APK**:
    ```bash
    cd native_app
    buildozer android debug
    ```

4.  L'APK sarà generato in `native_app/bin/budgetgiornaliero-1.0-debug.apk`.

5.  Trasferisci l'APK sul tuo smartphone Android e installalo.

> **Nota**: La prima compilazione richiederà molto tempo (30-60 minuti) perché Buildozer scaricherà Android SDK, NDK e altre dipendenze.

