#!/bin/bash
# Script per avviare Budget Giornaliero in modalità Simulatore iOS (iPhone 16 Pro)
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DISPLAY="${DISPLAY:-:0}"

cd "$DIR/flutter_app"

# Se il binario non esiste, compila prima
if [ ! -f "build/linux/x64/release/bundle/budget_giornaliero" ]; then
    echo "Compilazione dell'applicazione..."
    "$DIR/flutter_sdk/bin/flutter" build linux
fi

echo "Avvio di Budget Giornaliero in modalità Simulatore iOS (iPhone 16 Pro)..."
exec "$DIR/flutter_app/build/linux/x64/release/bundle/budget_giornaliero" --ios "$@"
