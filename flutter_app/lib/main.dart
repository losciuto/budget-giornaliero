import 'dart:convert';
import 'dart:io' show Platform, File;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'search_filter_screen.dart';
import 'smart_features.dart';
import 'package:local_notifier/local_notifier.dart';
import 'app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isWindows || Platform.isLinux) {
    await localNotifier.setup(
      appName: 'Budget Giornaliero',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }
  
  tz.initializeTimeZones();
  runApp(const BudgetApp());
}

// Intent classes for keyboard shortcuts
class _AddExpenseIntent extends Intent {
  const _AddExpenseIntent();
}

class _SearchIntent extends Intent {
  const _SearchIntent();
}

class _StatisticsIntent extends Intent {
  const _StatisticsIntent();
}

class _ExportIntent extends Intent {
  const _ExportIntent();
}

class _BackupIntent extends Intent {
  const _BackupIntent();
}

class _SettingsIntent extends Intent {
  const _SettingsIntent();
}

class _RefreshIntent extends Intent {
  const _RefreshIntent();
}

// AppStrings moved to app_strings.dart

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
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;

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
    // Android & iOS initialization
    if (Platform.isAndroid || Platform.isIOS) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      
      await _notificationsPlugin.initialize(initializationSettings);
    }
    // Desktop initialization is handled in main()
  }

  Future<void> _scheduleNotification() async {
    if (!_notificationsEnabled) {
      if (Platform.isAndroid) {
        await _notificationsPlugin.cancelAll();
      }
      return;
    }

    // Windows & Linux: Show immediate notification (since scheduling requires background service)
    if (Platform.isWindows || Platform.isLinux) {
      final notification = LocalNotification(
        identifier: 'daily_budget_reminder',
        title: AppStrings.get(context, 'notification_title', languageCode: _selectedLanguage),
        body: AppStrings.get(context, 'notification_body', languageCode: _selectedLanguage)
            .replaceAll('{amount}', _currencyFormat.format(_calculatedDaily)),
      );
      
      notification.show();
      return;
    }

    // Android: Schedule daily notification
    if (Platform.isAndroid) {

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
      
      // Load Budget Period
      final periodStr = prefs.getString('budget_period') ?? 'monthly';
      _selectedPeriod = BudgetPeriod.values.firstWhere(
        (p) => p.toString().split('.').last == periodStr,
        orElse: () => BudgetPeriod.monthly,
      );
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
    await prefs.setString('budget_period', _selectedPeriod.toString().split('.').last);
    _scheduleNotification();
  }

  void _updateCalculations() {
    setState(() {
      final today = DateTime.now();
      int diff = BudgetLogic.getDaysRemaining(today, _targetDate);
      
      if (diff <= 0) {
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

  void _showSearchFilter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchFilterScreen(
          expenses: _expenses,
          languageCode: _selectedLanguage,
          currencyFormat: _currencyFormat,
        ),
      ),
    );
  }

  void _showSmartSuggestions() {
    final suggestions = SmartFeatures.generateSuggestions(
      expenses: _expenses,
      totalBudget: double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0,
      dailyBudget: _dailyBudget,
      daysRemaining: int.tryParse(_daysRemaining) ?? 0,
      languageCode: _selectedLanguage,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.amber),
            const SizedBox(width: 10),
            Text(AppStrings.get(context, 'smart_suggestions_title', languageCode: _selectedLanguage)),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: suggestions.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    AppStrings.get(context, 'no_suggestions', languageCode: _selectedLanguage), // Assicurati che questa stringa esista o usa un fallback
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: suggestion.color.withOpacity(0.1),
                      child: ListTile(
                        leading: Icon(suggestion.icon, color: suggestion.color, size: 32),
                        title: Text(
                          suggestion.title,
                          style: TextStyle(fontWeight: FontWeight.bold, color: suggestion.color),
                        ),
                        subtitle: Text(suggestion.message),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get(context, 'close', languageCode: _selectedLanguage)),
          ),
        ],
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
                    title: Text(AppStrings.get(context, 'language_label', languageCode: _selectedLanguage)),
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
                    title: Text(AppStrings.get(context, 'currency_label', languageCode: _selectedLanguage)),
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
                  
                  // Budget Period Selection
                  ListTile(
                    title: Text(AppStrings.get(context, 'period', languageCode: _selectedLanguage)),
                    trailing: DropdownButton<BudgetPeriod>(
                      value: _selectedPeriod,
                      onChanged: (BudgetPeriod? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedPeriod = newValue;
                            // Ricalcola la data target in base al nuovo periodo
                            _targetDate = BudgetLogic.getNextTargetDate(DateTime.now(), _selectedPeriod);
                          });
                          _updateCalculations();
                        }
                      },
                      items: BudgetPeriod.values.where((p) => p != BudgetPeriod.custom).map((period) {
                        String label;
                        switch (period) {
                          case BudgetPeriod.monthly:
                            label = AppStrings.get(context, 'period_monthly', languageCode: _selectedLanguage);
                            break;
                          case BudgetPeriod.weekly:
                            label = AppStrings.get(context, 'period_weekly', languageCode: _selectedLanguage);
                            break;
                          case BudgetPeriod.biweekly:
                            label = AppStrings.get(context, 'period_biweekly', languageCode: _selectedLanguage);
                            break;
                          case BudgetPeriod.yearly:
                            label = AppStrings.get(context, 'period_yearly', languageCode: _selectedLanguage);
                            break;
                          default:
                            label = period.toString();
                        }
                        return DropdownMenuItem<BudgetPeriod>(
                          value: period,
                          child: Text(label),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const Divider(),

                  // Show notifications option on supported platforms
                  if (Platform.isAndroid || Platform.isIOS || Platform.isWindows || Platform.isLinux)
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
                  if (Platform.isAndroid || Platform.isIOS || Platform.isWindows || Platform.isLinux)
                    const Divider(),
                  Text(
                    "${AppStrings.get(context, 'author', languageCode: _selectedLanguage)}: Massimo Lo Sciuto\n"
                    "${AppStrings.get(context, 'support', languageCode: _selectedLanguage)}: Antigravity\n"
                    "${AppStrings.get(context, 'development', languageCode: _selectedLanguage)}: Gemini 3 Pro\n"
                    "${AppStrings.get(context, 'version', languageCode: _selectedLanguage)}: 2.3.0 (Flutter)",
                  ),
                  const SizedBox(height: 12),
                  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                    const Text(
                      "Shortcuts: Ctrl+N (Nuova), Ctrl+F (Ricerca),\n"
                      "Ctrl+S (Statistiche), Ctrl+E (Export),\n"
                      "Ctrl+B (Backup), Ctrl+, (Impostazioni), F5 (Aggiorna)",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
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

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN): const _AddExpenseIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF): const _SearchIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): const _StatisticsIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyE): const _ExportIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB): const _BackupIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.comma): const _SettingsIntent(),
        LogicalKeySet(LogicalKeyboardKey.f5): const _RefreshIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _AddExpenseIntent: CallbackAction<_AddExpenseIntent>(
            onInvoke: (_) {
              _showAddExpenseDialog();
              return null;
            },
          ),
          _SearchIntent: CallbackAction<_SearchIntent>(
            onInvoke: (_) {
              _showSearchFilter();
              return null;
            },
          ),
          _StatisticsIntent: CallbackAction<_StatisticsIntent>(
            onInvoke: (_) {
              _showStatistics();
              return null;
            },
          ),
          _ExportIntent: CallbackAction<_ExportIntent>(
            onInvoke: (_) {
              _exportToExcel();
              return null;
            },
          ),
          _BackupIntent: CallbackAction<_BackupIntent>(
            onInvoke: (_) {
              _showBackupDialog();
              return null;
            },
          ),
          _SettingsIntent: CallbackAction<_SettingsIntent>(
            onInvoke: (_) {
              _showInfoDialog();
              return null;
            },
          ),
          _RefreshIntent: CallbackAction<_RefreshIntent>(
            onInvoke: (_) {
              _updateCalculations();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: _showAddExpenseDialog,
              tooltip: AppStrings.get(context, 'add_expense', languageCode: _selectedLanguage),
              child: const Icon(Icons.add),
            ),
            body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(16.0),
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
                    icon: const Icon(Icons.search, color: Colors.teal),
                    onPressed: _showSearchFilter,
                    tooltip: _selectedLanguage == 'it' ? 'Ricerca' : 'Search',
                  ),
                  IconButton(
                    icon: const Icon(Icons.lightbulb, color: Colors.amber),
                    onPressed: _showSmartSuggestions,
                    tooltip: AppStrings.get(context, 'smart_suggestions_title', languageCode: _selectedLanguage),
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
              const SizedBox(height: 12),

              // Main Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
              
              // Smart Suggestions removed from here and moved to header icon dialog
              
              // Expenses Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.get(context, 'expenses', languageCode: _selectedLanguage),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  if (_expenses.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 20),
                      tooltip: AppStrings.get(context, 'clear_all', languageCode: _selectedLanguage),
                      onPressed: _confirmClearAll,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                AppStrings.get(context, 'swipe_hint', languageCode: _selectedLanguage),
                style: const TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 4),

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
                              margin: const EdgeInsets.symmetric(vertical: 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(vertical: -4),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                minLeadingWidth: 0,
                                leading: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: expense.category.color.withOpacity(0.2),
                                  child: Icon(
                                    expense.category.icon,
                                    color: expense.category.color,
                                    size: 16,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(child: Text(expense.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                                    Text(
                                      expense.category.getName(_selectedLanguage),
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: expense.category.color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(_dateFormat.format(expense.date), style: const TextStyle(fontSize: 10)),
                                    const Spacer(),
                                    Text(
                                      '${AppStrings.get(context, 'remaining', languageCode: _selectedLanguage)}: ${_currencyFormat.format(remainingAfterExpense)}',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: remainingAfterExpense >= 0 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  _currencyFormat.format(expense.amount),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.redAccent,
                                  ),
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
          ),
        ),
      ),
    );
  }
}
