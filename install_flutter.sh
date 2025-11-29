#!/bin/bash
set -e

echo "=== Installazione Flutter SDK ==="

# Definizione variabili
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz"
INSTALL_DIR="flutter_sdk"
ARCHIVE_NAME="flutter.tar.xz"

# Creazione directory
if [ -d "$INSTALL_DIR" ]; then
    echo "La directory $INSTALL_DIR esiste già. Rimuoverla per reinstallare? (s/n)"
    read -r response
    if [[ "$response" =~ ^([sS][iI]|[sS])$ ]]; then
        rm -rf "$INSTALL_DIR"
    else
        echo "Installazione annullata."
        exit 0
    fi
fi

mkdir -p "$INSTALL_DIR"

# Download
echo "Scaricamento di Flutter da $FLUTTER_URL..."
curl -o "$ARCHIVE_NAME" "$FLUTTER_URL"

# Estrazione
echo "Estrazione dell'archivio..."
tar -xf "$ARCHIVE_NAME" -C "$INSTALL_DIR" --strip-components=1

# Pulizia
rm "$ARCHIVE_NAME"

# Configurazione finale
FLUTTER_BIN="$(pwd)/$INSTALL_DIR/bin"
echo ""
echo "=== Installazione Completata! ==="
echo "Flutter è stato installato in: $(pwd)/$INSTALL_DIR"
echo ""
echo "Per usare flutter in questo terminale, esegui:"
echo "export PATH=\"$FLUTTER_BIN:\$PATH\""
echo ""
echo "Per aggiungerlo permanentemente, aggiungi la riga sopra al tuo ~/.bashrc o ~/.zshrc"
echo ""
echo "Esecuzione di 'flutter doctor' per completare il setup..."
"$FLUTTER_BIN/flutter" doctor
