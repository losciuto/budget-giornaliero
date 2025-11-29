import os
import shutil
import subprocess
import sys
from pathlib import Path

def print_colored(text, color_code):
    print(f"\033[{color_code}m{text}\033[0m")

def main():
    print_colored("=== Esportazione Progetto Android Studio ===", "1;34")
    
    # Verifica presenza buildozer
    if shutil.which("buildozer") is None:
        print_colored("Errore: 'buildozer' non trovato. Assicurati che sia installato e nel PATH.", "1;31")
        sys.exit(1)

    # Directory corrente (native_app)
    base_dir = Path(".").resolve()
    buildozer_dir = base_dir / ".buildozer"
    output_dir = base_dir / "android_studio_project"

    print(f"Directory di lavoro: {base_dir}")

    # Esegui buildozer per generare il progetto (se necessario)
    print_colored("\nEsecuzione di buildozer per preparare il progetto...", "1;33")
    print("Questo passaggio potrebbe richiedere del tempo se è la prima volta.")
    try:
        # Usiamo 'debug' per assicurarci che tutto sia costruito. 
        # Non è necessario completare l'APK se vogliamo solo il progetto, ma è il modo più sicuro.
        subprocess.check_call(["buildozer", "android", "debug"], cwd=base_dir)
    except subprocess.CalledProcessError:
        print_colored("\nErrore durante l'esecuzione di buildozer.", "1;31")
        print("Controlla l'output sopra per i dettagli.")
        sys.exit(1)

    # Cerca la directory del progetto Android generato
    # Percorso tipico: .buildozer/android/platform/build-<arch>/dists/<package_name>
    # Cerchiamo ricorsivamente una cartella che contiene 'build.gradle' dentro .buildozer
    print_colored("\nRicerca del progetto Android generato...", "1;33")
    
    found_project = None
    if buildozer_dir.exists():
        for path in buildozer_dir.rglob("build.gradle"):
            # Escludiamo file build.gradle che potrebbero essere di librerie
            if "dists" in str(path) and "templates" not in str(path):
                found_project = path.parent
                break
    
    if not found_project:
        print_colored("Errore: Impossibile trovare il progetto Android generato.", "1;31")
        print(f"Assicurati che la cartella {buildozer_dir} esista e contenga una distribuzione valida.")
        sys.exit(1)

    print(f"Progetto trovato in: {found_project}")

    # Copia il progetto
    if output_dir.exists():
        print_colored(f"\nRimozione vecchia cartella {output_dir}...", "1;33")
        shutil.rmtree(output_dir)

    print_colored(f"Copia del progetto in {output_dir}...", "1;32")
    shutil.copytree(found_project, output_dir)

    print_colored("\n=== Esportazione Completata con Successo! ===", "1;32")
    print(f"Il progetto Android Studio è pronto in: {output_dir}")
    print("\nIstruzioni:")
    print("1. Apri Android Studio.")
    print(f"2. Seleziona 'Open' e naviga fino a: {output_dir}")
    print("3. Attendi la sincronizzazione di Gradle.")
    print("4. Ora puoi modificare, eseguire il debug e generare l'APK direttamente da Android Studio.")
    print("\nNota: Se modifichi il codice Python (main.py), devi rieseguire questo script per aggiornare il progetto Android Studio.")

if __name__ == "__main__":
    main()
