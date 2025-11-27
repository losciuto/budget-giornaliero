# Budget Giornaliero

Un'applicazione cross-platform (Linux, Windows, Android) per calcolare il budget giornaliero disponibile fino al 27 del mese corrente.

## Funzionalità
*   **Calcolo Automatico**: Conta i giorni mancanti al 27 del mese (incluso).
*   **Divisione Budget**: Divide l'importo inserito per i giorni rimanenti.
*   **Interfaccia Moderna**: Tema scuro (Dark Mode) realizzato con KivyMD.
*   **Cross-Platform**: Unico codice sorgente per tutte le piattaforme.

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

La compilazione per Android è gestita automaticamente tramite **GitHub Actions** (per evitare problemi con Buildozer su alcune distro Linux).

1.  Carica questo progetto su una repository **GitHub**.
2.  Vai nella scheda **Actions** della repository.
3.  Vedrai un workflow chiamato "Build Android APK" avviarsi automaticamente.
4.  Al termine, scarica il file `.apk` dalla sezione "Artifacts" del workflow completato.
5.  Installa l'APK sul tuo smartphone.
