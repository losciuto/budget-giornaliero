import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic.dart';

/// Service for managing persistent storage using SharedPreferences
class StorageService {
  static const String _keyTargetDate = 'target_date';
  static const String _keyAmount = 'amount';
  static const String _keyExpenses = 'expenses';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyLanguage = 'language';
  static const String _keyCurrency = 'currency';
  static const String _keyBudgetPeriod = 'budget_period';
  static const String _keyLastNotificationDate = 'last_notification_date';

  /// Load all budget data from storage
  static Future<BudgetData> loadBudgetData() async {
    final prefs = await SharedPreferences.getInstance();
    
    return BudgetData(
      targetDate: _loadTargetDate(prefs),
      amount: prefs.getString(_keyAmount) ?? '',
      expenses: _loadExpenses(prefs),
      notificationsEnabled: prefs.getBool(_keyNotificationsEnabled) ?? false,
      language: prefs.getString(_keyLanguage) ?? 'it',
      currency: prefs.getString(_keyCurrency) ?? 'EUR',
      budgetPeriod: _loadBudgetPeriod(prefs),
    );
  }

  /// Save all budget data to storage
  static Future<void> saveBudgetData(BudgetData data) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_keyTargetDate, data.targetDate.toIso8601String());
    await prefs.setString(_keyAmount, data.amount);
    await prefs.setStringList(
      _keyExpenses,
      data.expenses.map((e) => jsonEncode(e.toJson())).toList(),
    );
    await prefs.setBool(_keyNotificationsEnabled, data.notificationsEnabled);
    await prefs.setString(_keyLanguage, data.language);
    await prefs.setString(_keyCurrency, data.currency);
    await prefs.setString(_keyBudgetPeriod, data.budgetPeriod.toString().split('.').last);
  }

  /// Get the last notification date
  static Future<String?> getLastNotificationDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastNotificationDate);
  }

  /// Set the last notification date
  static Future<void> setLastNotificationDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastNotificationDate, date);
  }

  // Private helper methods
  static DateTime _loadTargetDate(SharedPreferences prefs) {
    final dateStr = prefs.getString(_keyTargetDate);
    if (dateStr != null) {
      return DateTime.parse(dateStr);
    }
    return BudgetLogic.getInitialTargetDate(DateTime.now());
  }

  static List<Expense> _loadExpenses(SharedPreferences prefs) {
    final expensesJson = prefs.getStringList(_keyExpenses);
    if (expensesJson != null) {
      return expensesJson
          .map((e) => Expense.fromJson(jsonDecode(e)))
          .toList();
    }
    return [];
  }

  static BudgetPeriod _loadBudgetPeriod(SharedPreferences prefs) {
    final periodStr = prefs.getString(_keyBudgetPeriod) ?? 'monthly';
    return BudgetPeriod.values.firstWhere(
      (p) => p.toString().split('.').last == periodStr,
      orElse: () => BudgetPeriod.monthly,
    );
  }
}

/// Data class to hold all budget-related data
class BudgetData {
  final DateTime targetDate;
  final String amount;
  final List<Expense> expenses;
  final bool notificationsEnabled;
  final String language;
  final String currency;
  final BudgetPeriod budgetPeriod;

  BudgetData({
    required this.targetDate,
    required this.amount,
    required this.expenses,
    required this.notificationsEnabled,
    required this.language,
    required this.currency,
    required this.budgetPeriod,
  });

  BudgetData copyWith({
    DateTime? targetDate,
    String? amount,
    List<Expense>? expenses,
    bool? notificationsEnabled,
    String? language,
    String? currency,
    BudgetPeriod? budgetPeriod,
  }) {
    return BudgetData(
      targetDate: targetDate ?? this.targetDate,
      amount: amount ?? this.amount,
      expenses: expenses ?? this.expenses,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      budgetPeriod: budgetPeriod ?? this.budgetPeriod,
    );
  }
}
