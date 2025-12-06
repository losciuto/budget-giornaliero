# 💰 Presupuesto Diario (Budget Giornaliero)

Una aplicación Flutter simple y potente para gestionar tu presupuesto mensual y controlar los gastos diarios.

![Versión](https://img.shields.io/badge/version-2.4.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B.svg)
![Plataforma](https://img.shields.io/badge/platform-Android%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)

## ✨ Características Principales

*   **📅 Cálculo Automático**: Calcula cuánto puedes gastar hoy basándose en tu presupuesto mensual y los días restantes.
*   **🏷️ Categorías de Gastos**: Organiza tus gastos con iconos y colores (Comida, Transporte, Ocio, etc.).
*   **📊 Estadísticas Gráficas**: Visualiza tus gastos con gráficos circulares y de barras interactivos.
*   **💾 Copia de Seguridad Completa**: Exporta e importa todos tus datos (JSON) para no perder nada.
*   **📱 Multiplataforma**: Funciona perfectamente en Android, Linux y Windows.
*   **🔔 Notificaciones Diarias**: Recibe un recordatorio con tu presupuesto restante (Android, Windows, Linux).
*   **🔍 Búsqueda y Filtros**: Encuentra gastos por descripción, categoría o fecha.
*   **💡 Sugerencias Inteligentes**: Consejos automáticos basados en tus hábitos de gasto.
*   **🌍 Multilingüe**: Disponible en Italiano, Inglés, Español, Francés y Alemán.
*   **💱 Multidivisa**: Soporte para más de 20 monedas (EUR, USD, GBP, JPY, etc.).
*   **📤 Exportación Excel**: Exporta tu historial de gastos a un archivo Excel (.xlsx).
*   **🌙 Modo Oscuro**: Interfaz limpia y moderna que respeta el tema de tu sistema.

## 🚀 Instalación

### Android
Descarga e instala el archivo `.apk` desde la carpeta `build/app/outputs/flutter-apk/`.

### Windows
1.  Descarga el código fuente.
2.  Ejecuta `build_windows.bat` para compilar.
3.  El ejecutable estará en `build/windows/runner/Release/`.

### Linux
1.  Asegúrate de tener Flutter instalado.
2.  Ejecuta `flutter build linux --release`.
3.  Ejecuta la aplicación desde `build/linux/x64/release/bundle/`.

## 📖 Cómo Usar

1.  **Configuración Inicial**: Establece tu presupuesto total y la fecha de fin de mes.
2.  **Añadir Gastos**: Pulsa el botón `+`, selecciona una categoría e introduce el monto.
3.  **Monitorizar**: Observa cómo se actualiza tu presupuesto diario disponible.
4.  **Estadísticas**: Pulsa el icono 📊 para ver gráficos detallados.
5.  **Copia de Seguridad**: Pulsa el icono 💾 para guardar tus datos.

## 🛠️ Tecnologías

*   **Flutter & Dart**: Framework principal.
*   **shared_preferences**: Persistencia de datos local.
*   **fl_chart**: Gráficos y estadísticas.
*   **file_picker**: Selección de archivos.
*   **flutter_local_notifications**: Notificaciones locales.
*   **excel**: Exportación de datos.

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

---
**Autor**: [losciuto](https://github.com/losciuto/budget-giornaliero)  
**Desarrollado con**: Antigravity (Gemini 3 Pro)
