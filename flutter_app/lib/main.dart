import 'dart:convert';
import 'dart:io' show Platform, File;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'logic.dart';
import 'statistics_screen.dart';
import 'backup_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const BudgetApp());
}

// Simple Localization
class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'it': {
      'title': 'Budget Giornaliero',
      'subtitle': 'Gestione spese mensili',
      'target_date': 'Data Fine Budget',
      'total_budget': 'Importo Disponibile',
      'hint_budget': 'Inserisci il tuo budget totale',
      'today': 'Data di Oggi',
      'days_remaining': 'Giorni Mancanti',
      'daily_available': 'Puoi spendere al giorno:',
      'expired': 'Scaduto',
      'info': 'Informazioni',
      'add_expense': 'Aggiungi Spesa',
      'expenses': 'Spese Recenti',
      'no_expenses': 'Nessuna spesa registrata',
      'spent': 'Totale Speso',
      'remaining': 'Rimanente',
      'description': 'Descrizione',
      'amount': 'Importo',
      'cancel': 'Annulla',
      'add': 'Aggiungi',
      'notification_title': 'Budget Giornaliero',
      'notification_body': 'Hai ancora {amount} disponibili per oggi!',
      'settings': 'Impostazioni',
      'enable_notifications': 'Abilita Notifiche Giornaliere',
      'export_excel': 'Esporta in Excel',
      'export_success': 'File esportato con successo!',
      'export_error': 'Errore durante l\'esportazione',
      'swipe_hint': 'Scorri per eliminare',
      'clear_all': 'Cancella Tutto',
      'confirm_clear_all': 'Sei sicuro di voler cancellare tutte le spese?',
      'yes': 'Sì',
      'no': 'No',
      'category': 'Categoria',
      'statistics': 'Statistiche',
      'backup': 'Backup',
      'backup_export': 'Esporta Backup',
      'backup_import': 'Importa Backup',
      'backup_success': 'Backup creato con successo!',
      'backup_error': 'Errore durante il backup',
      'import_success': 'Dati importati con successo!',
      'import_error': 'Errore durante l\'importazione',
    },
    'en': {
      'title': 'Daily Budget',
      'subtitle': 'Monthly expense management',
      'target_date': 'Budget End Date',
      'total_budget': 'Available Amount',
      'hint_budget': 'Enter your total budget',
      'today': 'Today\'s Date',
      'days_remaining': 'Days Remaining',
      'daily_available': 'You can spend daily:',
      'expired': 'Expired',
      'info': 'Info',
      'add_expense': 'Add Expense',
      'expenses': 'Recent Expenses',
      'no_expenses': 'No expenses recorded',
      'spent': 'Total Spent',
      'remaining': 'Remaining',
      'description': 'Description',
      'amount': 'Amount',
      'cancel': 'Cancel',
      'add': 'Add',
      'notification_title': 'Daily Budget',
      'notification_body': 'You still have {amount} available for today!',
      'settings': 'Settings',
      'enable_notifications': 'Enable Daily Notifications',
      'export_excel': 'Export to Excel',
      'export_success': 'File exported successfully!',
      'export_error': 'Error during export',
      'swipe_hint': 'Swipe to delete',
      'clear_all': 'Clear All',
      'confirm_clear_all': 'Are you sure you want to delete all expenses?',
      'yes': 'Yes',
      'no': 'No',
      'category': 'Category',
      'statistics': 'Statistics',
      'backup': 'Backup',
      'backup_export': 'Export Backup',
      'backup_import': 'Import Backup',
      'backup_success': 'Backup created successfully!',
      'backup_error': 'Error during backup',
      'import_success': 'Data imported successfully!',
      'import_error': 'Error during import',
    },
    'es': {
      'title': 'Presupuesto Diario',
      'subtitle': 'Gestión de gastos mensuales',
      'target_date': 'Fecha Fin Presupuesto',
      'total_budget': 'Monto Disponible',
      'hint_budget': 'Introduce tu presupuesto total',
      'today': 'Fecha de Hoy',
      'days_remaining': 'Días Restantes',
      'daily_available': 'Puedes gastar al día:',
      'expired': 'Caducado',
      'info': 'Información',
      'add_expense': 'Añadir Gasto',
      'expenses': 'Gastos Recientes',
      'no_expenses': 'No hay gastos registrados',
      'spent': 'Total Gastado',
      'remaining': 'Restante',
      'description': 'Descripción',
      'amount': 'Monto',
      'cancel': 'Cancelar',
      'add': 'Añadir',
      'notification_title': 'Presupuesto Diario',
      'notification_body': '¡Todavía tienes {amount} disponibles para hoy!',
      'settings': 'Ajustes',
      'enable_notifications': 'Activar Notificaciones Diarias',
      'export_excel': 'Exportar a Excel',
      'export_success': '¡Archivo exportado con éxito!',
      'export_error': 'Error durante la exportación',
      'swipe_hint': 'Desliza para eliminar',
      'clear_all': 'Borrar Todo',
      'confirm_clear_all': '¿Estás seguro de que quieres borrar todos los gastos?',
      'yes': 'Sí',
      'no': 'No',
      'category': 'Categoría',
      'statistics': 'Estadísticas',
      'backup': 'Copia de Seguridad',
      'backup_export': 'Exportar Copia',
      'backup_import': 'Importar Copia',
      'backup_success': '¡Copia creada con éxito!',
      'backup_error': 'Error durante la copia',
      'import_success': '¡Datos importados con éxito!',
      'import_error': 'Error durante la importación',
    },
    'fr': {
      'title': 'Budget Quotidien',
      'subtitle': 'Gestion des dépenses mensuelles',
      'target_date': 'Date Fin Budget',
      'total_budget': 'Montant Disponible',
      'hint_budget': 'Entrez votre budget total',
      'today': 'Date d\'Aujourd\'hui',
      'days_remaining': 'Jours Restants',
      'daily_available': 'Vous pouvez dépenser par jour :',
      'expired': 'Expiré',
      'info': 'Infos',
      'add_expense': 'Ajouter Dépense',
      'expenses': 'Dépenses Récentes',
      'no_expenses': 'Aucune dépense enregistrée',
      'spent': 'Total Dépensé',
      'remaining': 'Restant',
      'description': 'Description',
      'amount': 'Montant',
      'cancel': 'Annuler',
      'add': 'Ajouter',
      'notification_title': 'Budget Quotidien',
      'notification_body': 'Vous avez encore {amount} disponibles pour aujourd\'hui !',
      'settings': 'Paramètres',
      'enable_notifications': 'Activer Notifications Quotidiennes',
      'export_excel': 'Exporter vers Excel',
      'export_success': 'Fichier exporté avec succès !',
      'export_error': 'Erreur lors de l\'exportation',
      'swipe_hint': 'Glisser pour supprimer',
      'clear_all': 'Tout Effacer',
      'confirm_clear_all': 'Êtes-vous sûr de vouloir supprimer toutes les dépenses ?',
      'yes': 'Oui',
      'no': 'Non',
      'category': 'Catégorie',
      'statistics': 'Statistiques',
      'backup': 'Sauvegarde',
      'backup_export': 'Exporter Sauvegarde',
      'backup_import': 'Importer Sauvegarde',
      'backup_success': 'Sauvegarde créée avec succès !',
      'backup_error': 'Erreur lors de la sauvegarde',
      'import_success': 'Données importées avec succès !',
      'import_error': 'Erreur lors de l\'importation',
    },
    'de': {
      'title': 'Tagesbudget',
      'subtitle': 'Monatliche Ausgabenverwaltung',
      'target_date': 'Budget-Enddatum',
      'total_budget': 'Verfügbarer Betrag',
      'hint_budget': 'Geben Sie Ihr Gesamtbudget ein',
      'today': 'Heutiges Datum',
      'days_remaining': 'Verbleibende Tage',
      'daily_available': 'Sie können täglich ausgeben:',
      'expired': 'Abgelaufen',
      'info': 'Info',
      'add_expense': 'Ausgabe Hinzufügen',
      'expenses': 'Letzte Ausgaben',
      'no_expenses': 'Keine Ausgaben erfasst',
      'spent': 'Gesamt Ausgegeben',
      'remaining': 'Verbleibend',
      'description': 'Beschreibung',
      'amount': 'Betrag',
      'cancel': 'Abbrechen',
      'add': 'Hinzufügen',
      'notification_title': 'Tagesbudget',
      'notification_body': 'Sie haben noch {amount} für heute verfügbar!',
      'settings': 'Einstellungen',
      'enable_notifications': 'Tägliche Benachrichtigungen aktivieren',
      'export_excel': 'Nach Excel exportieren',
      'export_success': 'Datei erfolgreich exportiert!',
      'export_error': 'Fehler beim Exportieren',
      'swipe_hint': 'Zum Löschen wischen',
      'clear_all': 'Alles Löschen',
      'confirm_clear_all': 'Sind Sie sicher, dass Sie alle Ausgaben löschen möchten?',
      'yes': 'Ja',
      'no': 'Nein',
      'category': 'Kategorie',
      'statistics': 'Statistiken',
      'backup': 'Sicherung',
      'backup_export': 'Sicherung Exportieren',
      'backup_import': 'Sicherung Importieren',
      'backup_success': 'Sicherung erfolgreich erstellt!',
      'backup_error': 'Fehler bei der Sicherung',
      'import_success': 'Daten erfolgreich importiert!',
      'import_error': 'Fehler beim Importieren',
    },
  };

  static String get(BuildContext context, String key, {String? languageCode}) {
    final locale = languageCode ?? Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['it']![key]!;
  }
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Giornaliero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E),
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it', 'IT'),
        Locale('en', 'US'),
      ],
      home: const BudgetHomeScreen(),
    );
  }
}

class BudgetHomeScreen extends StatefulWidget {
  const BudgetHomeScreen({super.key});

  @override
  State<BudgetHomeScreen> createState() => _BudgetHomeScreenState();
}

class _BudgetHomeScreenState extends State<BudgetHomeScreen> {
  late DateTime _targetDate;
  final TextEditingController _amountController = TextEditingController();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  String _daysRemaining = "--";
  double _dailyBudget = 0.0;
  double _calculatedDaily = 0.0;
  double _totalSpent = 0.0;
  List<Expense> _expenses = [];
  bool _notificationsEnabled = false;
  
  // Language and Currency settings
  String _selectedLanguage = 'it';
  String _selectedCurrency = 'EUR';

  late DateFormat _dateFormat;
  late NumberFormat _currencyFormat;

  @override
  void initState() {
    super.initState();
    _targetDate = BudgetLogic.getInitialTargetDate(DateTime.now());
    _initNotifications();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFormatters();
  }
  
  void _updateFormatters() {
    _dateFormat = DateFormat('dd/MM/yyyy', _selectedLanguage);
    _currencyFormat = NumberFormat.currency(
      locale: _selectedLanguage,
      symbol: _getCurrencySymbol(_selectedCurrency),
      decimalDigits: 2,
    );
  }
  
  String _getCurrencySymbol(String code) {
    const currencySymbols = {
      'EUR': '€',
      'USD': '\$',
      'GBP': '£',
      'JPY': '¥',
      'CHF': 'CHF',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CNY': '¥',
      'INR': '₹',
      'BRL': 'R\$',
      'RUB': '₽',
      'KRW': '₩',
      'MXN': 'MX\$',
      'ZAR': 'R',
      'SEK': 'kr',
      'NOK': 'kr',
      'DKK': 'kr',
      'PLN': 'zł',
      'TRY': '₺',
      'AED': 'د.إ',
    };
    return currencySymbols[code] ?? code;
  }

  Future<void> _initNotifications() async {
    // Notifications are only supported on Android and iOS
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification() async {
    // Notifications are only supported on Android
    if (!Platform.isAndroid) {
      return;
    }
    
    if (!_notificationsEnabled) {
      await _notificationsPlugin.cancelAll();
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      0,
      AppStrings.get(context, 'notification_title', languageCode: _selectedLanguage),
      AppStrings.get(context, 'notification_body', languageCode: _selectedLanguage).replaceAll('{amount}', _currencyFormat.format(_calculatedDaily)),
      _nextInstanceOf9AM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_budget_channel',
          'Daily Budget Notifications',
          channelDescription: 'Daily reminder of available budget',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOf9AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load Target Date
      final dateStr = prefs.getString('target_date');
      if (dateStr != null) {
        _targetDate = DateTime.parse(dateStr);
      }

      // Load Amount
      final amount = prefs.getString('amount');
      if (amount != null) {
        _amountController.text = amount;
      }

      // Load Expenses
      final expensesJson = prefs.getStringList('expenses');
      if (expensesJson != null) {
        _expenses = expensesJson.map((e) => Expense.fromJson(jsonDecode(e))).toList();
      }

      // Load Notifications
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;

      // Load Language and Currency
      _selectedLanguage = prefs.getString('language') ?? 'it';
      _selectedCurrency = prefs.getString('currency') ?? 'EUR';
    });
    _updateFormatters();
    _updateCalculations();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('target_date', _targetDate.toIso8601String());
    await prefs.setString('amount', _amountController.text);
    await prefs.setStringList('expenses', _expenses.map((e) => jsonEncode(e.toJson())).toList());
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setString('language', _selectedLanguage);
    await prefs.setString('currency', _selectedCurrency);
    _scheduleNotification();
  }

  void _updateCalculations() {
    setState(() {

      
      final today = DateTime.now();
      final todayMidnight = DateTime(today.year, today.month, today.day);
      final targetMidnight = DateTime(_targetDate.year, _targetDate.month, _targetDate.day);
      
      int diff = targetMidnight.difference(todayMidnight).inDays + 1;
      
      if (targetMidnight.isBefore(todayMidnight)) {
        _daysRemaining = AppStrings.get(context, 'expired', languageCode: _selectedLanguage);
        diff = 0;
      } else {
        _daysRemaining = diff.toString();
      }

      double amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
      _totalSpent = BudgetLogic.calculateTotalExpenses(_expenses);
      _calculatedDaily = BudgetLogic.calculateDailyBudget(amount, _totalSpent, diff);
      
      _dailyBudget = _calculatedDaily;
    });
    _saveData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
      _updateCalculations();
    }
  }

  void _showAddExpenseDialog() {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategoryId = 'other'; // Default categoria

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppStrings.get(context, 'add_expense', languageCode: _selectedLanguage)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: AppStrings.get(context, 'description', languageCode: _selectedLanguage),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: AppStrings.get(context, 'amount', languageCode: _selectedLanguage),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              // Selezione Categoria
              DropdownButtonFormField<String>(
                value: selectedCategoryId,
                decoration: InputDecoration(
                  labelText: AppStrings.get(context, 'category', languageCode: _selectedLanguage),
                  border: const OutlineInputBorder(),
                ),
                items: ExpenseCategory.defaultCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Row(
                      children: [
                        Icon(category.icon, color: category.color, size: 20),
                        const SizedBox(width: 12),
                        Text(category.getName(_selectedLanguage)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategoryId = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.get(context, 'cancel', languageCode: _selectedLanguage)),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.replaceAll(',', '.'));
                if (amount != null && amount > 0) {
                  this.setState(() {
                    _expenses.insert(0, Expense(
                      amount: amount,
                      description: descController.text.isEmpty ? 'Spesa' : descController.text,
                      date: DateTime.now(),
                      categoryId: selectedCategoryId,
                    ));
                  });
                  _updateCalculations();
                  Navigator.pop(context);
                }
              },
              child: Text(AppStrings.get(context, 'add', languageCode: _selectedLanguage)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get(context, 'clear_all', languageCode: _selectedLanguage)),
        content: Text(AppStrings.get(context, 'confirm_clear_all', languageCode: _selectedLanguage)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get(context, 'no', languageCode: _selectedLanguage)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _expenses.clear();
              });
              _updateCalculations();
              Navigator.pop(context);
            },
            child: Text(AppStrings.get(context, 'yes', languageCode: _selectedLanguage), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _exportToExcel() async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Budget'];

      // Define styles
      final headerStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#2196F3'),
        fontColorHex: ExcelColor.white,
        fontSize: 14,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );

      final labelStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#E3F2FD'),
      );

      final currencyStyle = CellStyle(
        numberFormat: NumFormat.standard_2,
      );

      final positiveStyle = CellStyle(
        numberFormat: NumFormat.standard_2,
        fontColorHex: ExcelColor.fromHexString('#4CAF50'),
      );

      final negativeStyle = CellStyle(
        numberFormat: NumFormat.standard_2,
        fontColorHex: ExcelColor.fromHexString('#F44336'),
      );

      final expenseHeaderStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#90CAF9'),
        horizontalAlign: HorizontalAlign.Center,
      );

      // Summary section
      sheet.appendRow([TextCellValue('RIEPILOGO BUDGET')]);
      sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('D1'));
      sheet.cell(CellIndex.indexByString('A1')).cellStyle = headerStyle;
      sheet.setRowHeight(0, 25);
      
      final totalBudget = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
      final remaining = totalBudget - _totalSpent;
      
      sheet.appendRow([TextCellValue('Budget Totale'), DoubleCellValue(totalBudget)]);
      sheet.cell(CellIndex.indexByString('A2')).cellStyle = labelStyle;
      sheet.cell(CellIndex.indexByString('B2')).cellStyle = currencyStyle;
      
      sheet.appendRow([TextCellValue('Totale Speso'), DoubleCellValue(_totalSpent)]);
      sheet.cell(CellIndex.indexByString('A3')).cellStyle = labelStyle;
      sheet.cell(CellIndex.indexByString('B3')).cellStyle = negativeStyle;
      
      sheet.appendRow([TextCellValue('Rimanente'), DoubleCellValue(remaining)]);
      sheet.cell(CellIndex.indexByString('A4')).cellStyle = labelStyle;
      sheet.cell(CellIndex.indexByString('B4')).cellStyle = remaining >= 0 ? positiveStyle : negativeStyle;
      
      sheet.appendRow([TextCellValue('Budget Giornaliero'), DoubleCellValue(_calculatedDaily)]);
      sheet.cell(CellIndex.indexByString('A5')).cellStyle = labelStyle;
      sheet.cell(CellIndex.indexByString('B5')).cellStyle = currencyStyle;
      
      sheet.appendRow([TextCellValue('Giorni Mancanti'), TextCellValue(_daysRemaining)]);
      sheet.cell(CellIndex.indexByString('A6')).cellStyle = labelStyle;
      
      sheet.appendRow([TextCellValue('Data Target'), TextCellValue(_dateFormat.format(_targetDate))]);
      sheet.cell(CellIndex.indexByString('A7')).cellStyle = labelStyle;
      
      sheet.appendRow([]);

      // Expenses section
      sheet.appendRow([TextCellValue('SPESE')]);
      sheet.merge(CellIndex.indexByString('A9'), CellIndex.indexByString('D9'));
      sheet.cell(CellIndex.indexByString('A9')).cellStyle = headerStyle;
      sheet.setRowHeight(8, 25);
      
      sheet.appendRow([TextCellValue('Data'), TextCellValue('Descrizione'), TextCellValue('Importo'), TextCellValue('Rimanente')]);
      for (int col = 0; col < 4; col++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 9)).cellStyle = expenseHeaderStyle;
      }
      
      // Sort expenses chronologically for the report (Oldest -> Newest)
      final sortedExpenses = List<Expense>.from(_expenses)..sort((a, b) => a.date.compareTo(b.date));

      double runningBalance = totalBudget;
      int rowIndex = 10;
      for (var expense in sortedExpenses) {
        runningBalance -= expense.amount;
        sheet.appendRow([
          TextCellValue(_dateFormat.format(expense.date)),
          TextCellValue(expense.description),
          DoubleCellValue(expense.amount),
          DoubleCellValue(runningBalance),
        ]);
        
        // Apply styles
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).cellStyle = negativeStyle;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex)).cellStyle = 
            runningBalance >= 0 ? positiveStyle : negativeStyle;
        rowIndex++;
      }

      // Set column widths
      sheet.setColumnWidth(0, 15);  // Data
      sheet.setColumnWidth(1, 30);  // Descrizione
      sheet.setColumnWidth(2, 12);  // Importo
      sheet.setColumnWidth(3, 12);  // Rimanente

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/budget_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final fileBytes = excel.save();
      
      if (fileBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppStrings.get(context, 'export_success', languageCode: _selectedLanguage)}\n$filePath'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.get(context, 'export_error', languageCode: _selectedLanguage)}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(
          expenses: _expenses,
          languageCode: _selectedLanguage,
          currencySymbol: _getCurrencySymbol(_selectedCurrency),
          currencyFormat: _currencyFormat,
        ),
      ),
    );
  }

  Future<void> _exportBackup() async {
    try {
      final data = await BackupManager.exportData(
        expenses: _expenses,
        targetDate: _targetDate.toIso8601String(),
        amount: _amountController.text,
        notificationsEnabled: _notificationsEnabled,
        language: _selectedLanguage,
        currency: _selectedCurrency,
      );

      if (!mounted) return;
      final filePath = await BackupManager.saveBackupToFile(data, context);

      if (filePath != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.get(context, 'backup_success', languageCode: _selectedLanguage)}\n$filePath'),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.get(context, 'backup_error', languageCode: _selectedLanguage)}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importBackup() async {
    try {
      final backupData = await BackupManager.loadBackupFromFile(context);

      if (backupData != null) {
        final importedData = BackupManager.importData(backupData);

        if (importedData != null) {
          setState(() {
            _targetDate = DateTime.parse(importedData['targetDate']);
            _amountController.text = importedData['amount'];
            _notificationsEnabled = importedData['notificationsEnabled'];
            _selectedLanguage = importedData['language'];
            _selectedCurrency = importedData['currency'];
            _expenses = importedData['expenses'];
          });

          _updateFormatters();
          _updateCalculations();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.get(context, 'import_success', languageCode: _selectedLanguage)),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.get(context, 'import_error', languageCode: _selectedLanguage)}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => BackupDialog(
        onExport: _exportBackup,
        onImport: _importBackup,
        languageCode: _selectedLanguage,
      ),
    );
  }


  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppStrings.get(context, 'settings', languageCode: _selectedLanguage)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language Selection
                  ListTile(
                    title: const Text("Lingua / Language"),
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLanguage = newValue;
                          });
                          _updateFormatters();
                          _updateCalculations();
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: 'it', child: Text('Italiano')),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'es', child: Text('Español')),
                        DropdownMenuItem(value: 'fr', child: Text('Français')),
                        DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                      ],
                    ),
                  ),
                  
                  // Currency Selection
                  ListTile(
                    title: const Text("Valuta / Currency"),
                    trailing: DropdownButton<String>(
                      value: _selectedCurrency,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCurrency = newValue;
                          });
                          _updateFormatters();
                          _updateCalculations();
                        }
                      },
                      items: ['EUR', 'USD', 'GBP', 'JPY', 'CHF', 'CAD', 'AUD', 'CNY', 'INR', 'BRL', 'RUB', 'KRW', 'MXN', 'ZAR', 'SEK', 'NOK', 'DKK', 'PLN', 'TRY', 'AED']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const Divider(),

                  // Show notifications option only on Android and iOS
                  if (Platform.isAndroid || Platform.isIOS)
                    SwitchListTile(
                      title: Text(AppStrings.get(context, 'enable_notifications', languageCode: _selectedLanguage)),
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                        // Update main state as well
                        this.setState(() {
                          _notificationsEnabled = value;
                        });
                        _saveData();
                      },
                    ),
                  if (Platform.isAndroid || Platform.isIOS)
                    const Divider(),
                  const Text(
                    "Autore: Massimo Lo Sciuto\n"
                    "Supporto: Antigravity\n"
                    "Sviluppo: Gemini 3 Pro\n"
                    "Versione: 2.2.0 (Flutter)",
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("CHIUDI"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress
    final today = DateTime.now();
    final totalDaysInMonth = DateUtils.getDaysInMonth(today.year, today.month);
    final daysPassed = today.day.toDouble();
    final progress = daysPassed / totalDaysInMonth;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.get(context, 'title', languageCode: _selectedLanguage),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          AppStrings.get(context, 'subtitle', languageCode: _selectedLanguage),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bar_chart, color: Colors.purple),
                    onPressed: _showStatistics,
                    tooltip: AppStrings.get(context, 'statistics', languageCode: _selectedLanguage),
                  ),
                  IconButton(
                    icon: const Icon(Icons.backup, color: Colors.orange),
                    onPressed: _showBackupDialog,
                    tooltip: AppStrings.get(context, 'backup', languageCode: _selectedLanguage),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_download, color: Colors.green),
                    onPressed: _exportToExcel,
                    tooltip: AppStrings.get(context, 'export_excel', languageCode: _selectedLanguage),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.blue),
                    onPressed: _showInfoDialog,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Main Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Date Picker
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.get(context, 'target_date', languageCode: _selectedLanguage), style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 5),
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                        _dateFormat.format(_targetDate),
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(AppStrings.get(context, 'days_remaining', languageCode: _selectedLanguage), style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 5),
                                Text(
                                  _daysRemaining,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Progress Bar
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 20),

                      // Amount Input
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: AppStrings.get(context, 'total_budget', languageCode: _selectedLanguage),
                          hintText: AppStrings.get(context, 'hint_budget', languageCode: _selectedLanguage),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.euro),
                        ),
                        style: const TextStyle(fontSize: 20),
                        onChanged: (value) => _updateCalculations(),
                      ),
                      const SizedBox(height: 20),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.get(context, 'spent', languageCode: _selectedLanguage), style: const TextStyle(color: Colors.redAccent)),
                          Text(_currencyFormat.format(_totalSpent), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.get(context, 'remaining', languageCode: _selectedLanguage), style: const TextStyle(color: Colors.greenAccent)),
                          Text(_currencyFormat.format((double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0) - _totalSpent), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                        ],
                      ),
                      const Divider(),
                      
                      // Result
                      Text(AppStrings.get(context, 'daily_available', languageCode: _selectedLanguage), style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 5),
                      Text(
                        _currencyFormat.format(_dailyBudget),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _calculatedDaily < 10 ? Colors.red : (_calculatedDaily > 50 ? Colors.green : Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Expenses Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.get(context, 'expenses', languageCode: _selectedLanguage),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (_expenses.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                      tooltip: AppStrings.get(context, 'clear_all', languageCode: _selectedLanguage),
                      onPressed: _confirmClearAll,
                    ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _showAddExpenseDialog,
                    icon: const Icon(Icons.add),
                    label: Text(AppStrings.get(context, 'add_expense', languageCode: _selectedLanguage)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                AppStrings.get(context, 'swipe_hint', languageCode: _selectedLanguage),
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),

              // Expenses List
              Expanded(
                child: _expenses.isEmpty
                    ? Center(child: Text(AppStrings.get(context, 'no_expenses', languageCode: _selectedLanguage), style: const TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _expenses.length,
                        itemBuilder: (context, index) {
                          final expense = _expenses[index];
                          // Calculate running balance up to this expense (chronologically)
                          // Since the list is reverse chronological (Newest first), we sum from this index to the end.
                          double spentUpToHere = 0.0;
                          for (int i = index; i < _expenses.length; i++) {
                            spentUpToHere += _expenses[i].amount;
                          }
                          final totalBudget = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
                          final remainingAfterExpense = totalBudget - spentUpToHere;
                          
                          return Dismissible(
                            key: Key(expense.date.toString()),
                            onDismissed: (direction) {
                              setState(() {
                                _expenses.removeAt(index);
                              });
                              _updateCalculations();
                            },
                            background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: expense.category.color.withOpacity(0.2),
                                  child: Icon(
                                    expense.category.icon,
                                    color: expense.category.color,
                                    size: 24,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(child: Text(expense.description)),
                                    Text(
                                      expense.category.getName(_selectedLanguage),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: expense.category.color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_dateFormat.format(expense.date)),
                                    Text(
                                      '${AppStrings.get(context, 'remaining', languageCode: _selectedLanguage)}: ${_currencyFormat.format(remainingAfterExpense)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: remainingAfterExpense < 0 ? Colors.red : Colors.greenAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  "- ${_currencyFormat.format(expense.amount)}",
                                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
