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
      'total_budget': 'Importo Disponibile (€)',
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
      'notification_body': 'Hai ancora €{amount} disponibili per oggi!',
      'settings': 'Impostazioni',
      'enable_notifications': 'Abilita Notifiche Giornaliere',
      'export_excel': 'Esporta in Excel',
      'export_success': 'File esportato con successo!',
      'export_error': 'Errore durante l\'esportazione',
      'swipe_hint': 'Scorri per eliminare',
    },
    'en': {
      'title': 'Daily Budget',
      'subtitle': 'Monthly expense management',
      'target_date': 'Budget End Date',
      'total_budget': 'Available Amount (€)',
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
      'notification_body': 'You still have €{amount} available for today!',
      'settings': 'Settings',
      'enable_notifications': 'Enable Daily Notifications',
      'export_excel': 'Export to Excel',
      'export_success': 'File exported successfully!',
      'export_error': 'Error during export',
      'swipe_hint': 'Swipe to delete',
    },
  };

  static String get(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
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
  String _dailyBudget = "€ 0.00";
  double _calculatedDaily = 0.0;
  double _totalSpent = 0.0;
  List<Expense> _expenses = [];
  bool _notificationsEnabled = false;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _targetDate = BudgetLogic.getInitialTargetDate(DateTime.now());
    _initNotifications();
    _loadData();
  }

  Future<void> _initNotifications() async {
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
      AppStrings.get(context, 'notification_title'),
      AppStrings.get(context, 'notification_body').replaceAll('{amount}', _calculatedDaily.toStringAsFixed(2)),
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
    });
    _updateCalculations();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('target_date', _targetDate.toIso8601String());
    await prefs.setString('amount', _amountController.text);
    await prefs.setStringList('expenses', _expenses.map((e) => jsonEncode(e.toJson())).toList());
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    _scheduleNotification();
  }

  void _updateCalculations() {
    setState(() {
      final days = BudgetLogic.calculateDays(DateTime.now(), targetDay: _targetDate.day);
      
      final today = DateTime.now();
      final todayMidnight = DateTime(today.year, today.month, today.day);
      final targetMidnight = DateTime(_targetDate.year, _targetDate.month, _targetDate.day);
      
      int diff = targetMidnight.difference(todayMidnight).inDays + 1;
      
      if (targetMidnight.isBefore(todayMidnight)) {
        _daysRemaining = AppStrings.get(context, 'expired');
        diff = 0;
      } else {
        _daysRemaining = diff.toString();
      }

      double amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
      _totalSpent = BudgetLogic.calculateTotalExpenses(_expenses);
      _calculatedDaily = BudgetLogic.calculateDailyBudget(amount, _totalSpent, diff);
      
      _dailyBudget = "€ ${_calculatedDaily.toStringAsFixed(2)}";
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get(context, 'add_expense')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: AppStrings.get(context, 'description')),
              textCapitalization: TextCapitalization.sentences,
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: AppStrings.get(context, 'amount')),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get(context, 'cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text.replaceAll(',', '.'));
              if (amount != null && amount > 0) {
                setState(() {
                  _expenses.insert(0, Expense(
                    amount: amount,
                    description: descController.text.isEmpty ? 'Spesa' : descController.text,
                    date: DateTime.now(),
                  ));
                });
                _updateCalculations();
                Navigator.pop(context);
              }
            },
            child: Text(AppStrings.get(context, 'add')),
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
      
      double runningBalance = totalBudget;
      int rowIndex = 10;
      for (var expense in _expenses) {
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
              content: Text('${AppStrings.get(context, 'export_success')}\n$filePath'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.get(context, 'export_error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppStrings.get(context, 'settings')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Text(AppStrings.get(context, 'enable_notifications')),
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
                  const Divider(),
                  const Text(
                    "Autore: Massimo Lo Sciuto\n"
                    "Supporto: Antigravity\n"
                    "Sviluppo: Gemini 3 Pro\n"
                    "Versione: 2.1.0 (Flutter)",
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
                          AppStrings.get(context, 'title'),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          AppStrings.get(context, 'subtitle'),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_download, color: Colors.green),
                    onPressed: _exportToExcel,
                    tooltip: AppStrings.get(context, 'export_excel'),
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
                                Text(AppStrings.get(context, 'target_date'), style: const TextStyle(color: Colors.grey)),
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
                                Text(AppStrings.get(context, 'days_remaining'), style: const TextStyle(color: Colors.grey)),
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
                          labelText: AppStrings.get(context, 'total_budget'),
                          hintText: AppStrings.get(context, 'hint_budget'),
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
                          Text(AppStrings.get(context, 'spent'), style: const TextStyle(color: Colors.redAccent)),
                          Text("€ ${_totalSpent.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.get(context, 'remaining'), style: const TextStyle(color: Colors.greenAccent)),
                          Text("€ ${((double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0) - _totalSpent).toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                        ],
                      ),
                      const Divider(),
                      
                      // Result
                      Text(AppStrings.get(context, 'daily_available'), style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 5),
                      Text(
                        _dailyBudget,
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
                    AppStrings.get(context, 'expenses'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddExpenseDialog,
                    icon: const Icon(Icons.add),
                    label: Text(AppStrings.get(context, 'add_expense')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                AppStrings.get(context, 'swipe_hint'),
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),

              // Expenses List
              Expanded(
                child: _expenses.isEmpty
                    ? Center(child: Text(AppStrings.get(context, 'no_expenses'), style: const TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _expenses.length,
                        itemBuilder: (context, index) {
                          final expense = _expenses[index];
                          // Calculate running balance up to this expense
                          double spentUpToHere = 0.0;
                          for (int i = 0; i <= index; i++) {
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
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.redAccent,
                                  child: Icon(Icons.remove, color: Colors.white, size: 16),
                                ),
                                title: Text(expense.description),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_dateFormat.format(expense.date)),
                                    Text(
                                      'Rimanente: € ${remainingAfterExpense.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: remainingAfterExpense < 0 ? Colors.red : Colors.greenAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  "- € ${expense.amount.toStringAsFixed(2)}",
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
