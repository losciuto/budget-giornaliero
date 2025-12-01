import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'logic.dart';

class BackupManager {
  /// Esporta tutti i dati in formato JSON
  static Future<Map<String, dynamic>> exportData({
    required List<Expense> expenses,
    required String targetDate,
    required String amount,
    required bool notificationsEnabled,
    required String language,
    required String currency,
  }) async {
    return {
      'version': '2.2.0',
      'exportDate': DateTime.now().toIso8601String(),
      'data': {
        'targetDate': targetDate,
        'amount': amount,
        'notificationsEnabled': notificationsEnabled,
        'language': language,
        'currency': currency,
        'expenses': expenses.map((e) => e.toJson()).toList(),
      },
    };
  }

  /// Salva il backup su file
  static Future<String?> saveBackupToFile(Map<String, dynamic> data, BuildContext context) async {
    try {
      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'budget_backup_$timestamp.json';
      
      if (Platform.isAndroid || Platform.isIOS) {
        // Mobile: salva in Documents
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(jsonString);
        return file.path;
      } else {
        // Desktop: chiedi all'utente dove salvare
        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Salva Backup',
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: ['json'],
        );
        
        if (result != null) {
          final file = File(result);
          await file.writeAsString(jsonString);
          return result;
        }
      }
    } catch (e) {
      debugPrint('Errore durante il salvataggio del backup: $e');
    }
    return null;
  }

  /// Carica un backup da file
  static Future<Map<String, dynamic>?> loadBackupFromFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Seleziona Backup',
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        
        // Verifica versione
        if (data['version'] == null) {
          throw Exception('File backup non valido');
        }
        
        return data;
      }
    } catch (e) {
      debugPrint('Errore durante il caricamento del backup: $e');
      rethrow;
    }
    return null;
  }

  /// Importa i dati da un backup
  static Map<String, dynamic>? importData(Map<String, dynamic> backupData) {
    try {
      final data = backupData['data'] as Map<String, dynamic>;
      
      return {
        'targetDate': data['targetDate'],
        'amount': data['amount'],
        'notificationsEnabled': data['notificationsEnabled'] ?? false,
        'language': data['language'] ?? 'it',
        'currency': data['currency'] ?? 'EUR',
        'expenses': (data['expenses'] as List)
            .map((e) => Expense.fromJson(e as Map<String, dynamic>))
            .toList(),
      };
    } catch (e) {
      debugPrint('Errore durante l\'importazione dei dati: $e');
      return null;
    }
  }

  /// Crea un backup automatico locale
  static Future<void> createAutoBackup({
    required List<Expense> expenses,
    required String targetDate,
    required String amount,
    required bool notificationsEnabled,
    required String language,
    required String currency,
  }) async {
    try {
      final data = await exportData(
        expenses: expenses,
        targetDate: targetDate,
        amount: amount,
        notificationsEnabled: notificationsEnabled,
        language: language,
        currency: currency,
      );
      
      final jsonString = jsonEncode(data);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/auto_backup.json');
      await file.writeAsString(jsonString);
      
      debugPrint('Backup automatico creato: ${file.path}');
    } catch (e) {
      debugPrint('Errore durante il backup automatico: $e');
    }
  }

  /// Ripristina dall'ultimo backup automatico
  static Future<Map<String, dynamic>?> restoreAutoBackup() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/auto_backup.json');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        return importData(data);
      }
    } catch (e) {
      debugPrint('Errore durante il ripristino del backup automatico: $e');
    }
    return null;
  }
}

/// Dialog per gestire backup e ripristino
class BackupDialog extends StatelessWidget {
  final VoidCallback onExport;
  final VoidCallback onImport;
  final String languageCode;

  const BackupDialog({
    super.key,
    required this.onExport,
    required this.onImport,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(languageCode == 'it' ? 'Backup e Ripristino' : 'Backup & Restore'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.upload_file, color: Colors.blue),
            title: Text(languageCode == 'it' ? 'Esporta Backup' : 'Export Backup'),
            subtitle: Text(
              languageCode == 'it' 
                  ? 'Salva tutti i dati in un file' 
                  : 'Save all data to a file',
            ),
            onTap: () {
              Navigator.pop(context);
              onExport();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.download, color: Colors.green),
            title: Text(languageCode == 'it' ? 'Importa Backup' : 'Import Backup'),
            subtitle: Text(
              languageCode == 'it' 
                  ? 'Ripristina dati da un file' 
                  : 'Restore data from a file',
            ),
            onTap: () {
              Navigator.pop(context);
              onImport();
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              languageCode == 'it'
                  ? 'Il backup include: spese, budget, impostazioni e preferenze.'
                  : 'Backup includes: expenses, budget, settings and preferences.',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(languageCode == 'it' ? 'Chiudi' : 'Close'),
        ),
      ],
    );
  }
}
