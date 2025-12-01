@echo off
echo ========================================
echo Budget Giornaliero - Build per Windows
echo ========================================
echo.

REM Verifica che Flutter sia installato
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERRORE: Flutter non trovato nel PATH!
    echo Installa Flutter e aggiungilo al PATH di sistema.
    echo Scarica da: https://docs.flutter.dev/get-started/install/windows
    pause
    exit /b 1
)

echo [1/5] Verifica ambiente Flutter...
flutter doctor

echo.
echo [2/5] Pulizia build precedenti...
flutter clean

echo.
echo [3/5] Download dipendenze...
flutter pub get

echo.
echo [4/5] Compilazione Release per Windows...
flutter build windows --release

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo BUILD COMPLETATA CON SUCCESSO!
    echo ========================================
    echo.
    echo L'eseguibile si trova in:
    echo build\windows\x64\runner\Release\
    echo.
    echo Per distribuire l'app, copia TUTTA la cartella Release
    echo.
    
    REM Apri la cartella con l'eseguibile
    echo Vuoi aprire la cartella con l'eseguibile? (S/N)
    set /p risposta=
    if /i "%risposta%"=="S" (
        start "" "build\windows\x64\runner\Release\"
    )
) else (
    echo.
    echo ========================================
    echo ERRORE DURANTE LA COMPILAZIONE!
    echo ========================================
    echo.
    echo Verifica i messaggi di errore sopra.
    echo Assicurati di aver installato:
    echo - Visual Studio 2022 con "Desktop development with C++"
    echo - Windows 10 SDK
    echo.
)

echo.
pause
