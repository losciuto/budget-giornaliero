# 💰 Budget Quotidien (Budget Giornaliero)

Une application Flutter simple et puissante pour gérer votre budget mensuel et contrôler vos dépenses quotidiennes.

![Version](https://img.shields.io/badge/version-2.4.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B.svg)
![Plateforme](https://img.shields.io/badge/platform-Android%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)

## ✨ Caractéristiques Principales

*   **📅 Calcul Automatique**: Calcule combien vous pouvez dépenser aujourd'hui en fonction de votre budget mensuel et des jours restants.
*   **🏷️ Catégories de Dépenses**: Organisez vos dépenses avec des icônes et des couleurs (Nourriture, Transport, Loisirs, etc.).
*   **📊 Statistiques Graphiques**: Visualisez vos dépenses avec des graphiques circulaires et à barres interactifs.
*   **💾 Sauvegarde Complète**: Exportez et importez toutes vos données (JSON) pour ne rien perdre.
*   **📱 Multiplateforme**: Fonctionne parfaitement sur Android, Linux et Windows.
*   **🔔 Notifications Quotidiennes**: Recevez un rappel avec votre budget restant (Android, Windows, Linux).
*   **🔍 Recherche et Filtres**: Trouvez des dépenses par description, catégorie ou date.
*   **💡 Suggestions Intelligentes**: Conseils automatiques basés sur vos habitudes de dépenses.
*   **🌍 Multilingue**: Disponible en Italien, Anglais, Espagnol, Français et Allemand.
*   **💱 Multi-devises**: Prise en charge de plus de 20 devises (EUR, USD, GBP, JPY, etc.).
*   **📤 Exportation Excel**: Exportez votre historique de dépenses vers un fichier Excel (.xlsx).
*   **🌙 Mode Sombre**: Interface propre et moderne qui respecte le thème de votre système.

## 🚀 Installation

### Android
Téléchargez et installez le fichier `.apk` depuis le dossier `build/app/outputs/flutter-apk/`.

### Windows
1.  Téléchargez le code source.
2.  Exécutez `build_windows.bat` pour compiler.
3.  L'exécutable se trouvera dans `build/windows/runner/Release/`.

### Linux
1.  Assurez-vous que Flutter est installé.
2.  Exécutez `flutter build linux --release`.
3.  Lancez l'application depuis `build/linux/x64/release/bundle/`.

## 📖 Comment Utiliser

1.  **Configuration Initiale**: Définissez votre budget total et la date de fin du mois.
2.  **Ajouter des Dépenses**: Appuyez sur le bouton `+`, sélectionnez une catégorie et entrez le montant.
3.  **Surveiller**: Regardez votre budget quotidien disponible se mettre à jour.
4.  **Statistiques**: Appuyez sur l'icône 📊 pour voir des graphiques détaillés.
5.  **Sauvegarde**: Appuyez sur l'icône 💾 pour sauvegarder vos données.

## 🛠️ Technologies

*   **Flutter & Dart**: Framework principal.
*   **shared_preferences**: Persistance des données locale.
*   **fl_chart**: Graphiques et statistiques.
*   **file_picker**: Sélection de fichiers.
*   **flutter_local_notifications**: Notifications locales.
*   **excel**: Exportation de données.

## 📄 Licence

Ce projet est sous licence MIT.

---
**Auteur**: [losciuto](https://github.com/losciuto/budget-giornaliero)  
**Développé avec**: Antigravity (Gemini 3 Pro)
