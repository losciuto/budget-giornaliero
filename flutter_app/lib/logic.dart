import 'package:flutter/material.dart';

// Categoria di spesa
class ExpenseCategory {
  final String id;
  final String nameIt;
  final String nameEn;
  final IconData icon;
  final Color color;

  const ExpenseCategory({
    required this.id,
    required this.nameIt,
    required this.nameEn,
    required this.icon,
    required this.color,
  });

  String getName(String languageCode) {
    return languageCode == 'it' ? nameIt : nameEn;
  }

  // Categorie predefinite
  static const List<ExpenseCategory> defaultCategories = [
    ExpenseCategory(
      id: 'food',
      nameIt: 'Cibo',
      nameEn: 'Food',
      icon: Icons.restaurant,
      color: Color(0xFFFF6B6B),
    ),
    ExpenseCategory(
      id: 'transport',
      nameIt: 'Trasporti',
      nameEn: 'Transport',
      icon: Icons.directions_car,
      color: Color(0xFF4ECDC4),
    ),
    ExpenseCategory(
      id: 'entertainment',
      nameIt: 'Svago',
      nameEn: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFFFFE66D),
    ),
    ExpenseCategory(
      id: 'shopping',
      nameIt: 'Shopping',
      nameEn: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFA8E6CF),
    ),
    ExpenseCategory(
      id: 'health',
      nameIt: 'Salute',
      nameEn: 'Health',
      icon: Icons.local_hospital,
      color: Color(0xFFFF8B94),
    ),
    ExpenseCategory(
      id: 'bills',
      nameIt: 'Bollette',
      nameEn: 'Bills',
      icon: Icons.receipt_long,
      color: Color(0xFFFFA07A),
    ),
    ExpenseCategory(
      id: 'mara',
      nameIt: 'Spese per Mara',
      nameEn: 'Mara\'s Expenses',
      icon: Icons.favorite,
      color: Color(0xFFE91E63),
    ),
    ExpenseCategory(
      id: 'cash',
      nameIt: 'Contante',
      nameEn: 'Cash',
      icon: Icons.payments,
      color: Color(0xFF4CAF50),
    ),
    ExpenseCategory(
      id: 'medicines',
      nameIt: 'Medicinali',
      nameEn: 'Medicines',
      icon: Icons.medication,
      color: Color(0xFF2196F3),
    ),
    ExpenseCategory(
      id: 'appliances',
      nameIt: 'Elettrodomestici',
      nameEn: 'Appliances',
      icon: Icons.kitchen,
      color: Color(0xFFCDDC39), // Lime-ish or Steel Blue
    ),
    ExpenseCategory(
      id: 'other',
      nameIt: 'Altro',
      nameEn: 'Other',
      icon: Icons.more_horiz,
      color: Color(0xFFB0B0B0),
    ),
  ];

  static ExpenseCategory? findById(String id) {
    try {
      return defaultCategories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }
}

class Expense {
  final double amount;
  final String description;
  final DateTime date;
  final String? categoryId; // Nullable per retrocompatibilità

  Expense({
    required this.amount,
    required this.description,
    required this.date,
    this.categoryId,
  });

  ExpenseCategory get category {
    if (categoryId != null) {
      return ExpenseCategory.findById(categoryId!) ?? ExpenseCategory.defaultCategories.last;
    }
    return ExpenseCategory.defaultCategories.last; // 'other' come default
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
        if (categoryId != null) 'categoryId': categoryId,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        amount: json['amount'],
        description: json['description'],
        date: DateTime.parse(json['date']),
        categoryId: json['categoryId'], // Può essere null per vecchi dati
      );
}


// Tipi di periodo budget
enum BudgetPeriod {
  monthly,
  weekly,
  biweekly,
  yearly,
  custom
}

class BudgetLogic {

  
  static int getDaysRemaining(DateTime now, DateTime targetDate) {
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final targetMidnight = DateTime(targetDate.year, targetDate.month, targetDate.day);
    return targetMidnight.difference(todayMidnight).inDays + 1;
  }

  /// Calcola il totale delle spese.
  static double calculateTotalExpenses(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  /// Calcola il budget giornaliero considerando le spese.
  static double calculateDailyBudget(double totalBudget, double totalExpenses, int days) {
    if (days <= 0) return 0.0;
    return (totalBudget - totalExpenses) / days;
  }
  
  /// Determina la data target iniziale basata sul periodo scelto.
  static DateTime getNextTargetDate(DateTime now, BudgetPeriod period, {int targetDay = 27}) {
    final today = DateTime(now.year, now.month, now.day);
    
    switch (period) {
      case BudgetPeriod.weekly:
        // Fine alla prossima Domenica
        int daysUntilSunday = DateTime.sunday - today.weekday;
        if (daysUntilSunday < 0) daysUntilSunday += 7;
        return today.add(Duration(days: daysUntilSunday));
        
      case BudgetPeriod.biweekly:
        // Fine tra 14 giorni (o prossimo ciclo di 2 settimane)
        return today.add(const Duration(days: 13)); // +13 perché oggi conta
        
      case BudgetPeriod.yearly:
        // Fine dell'anno corrente
        return DateTime(today.year, 12, 31);
        
      case BudgetPeriod.monthly:
      default:
        // Logica mensile esistente (default giorno 27)
        if (today.day > targetDay) {
          if (today.month == 12) {
            return DateTime(today.year + 1, 1, targetDay);
          } else {
            return DateTime(today.year, today.month + 1, targetDay);
          }
        } else {
          return DateTime(today.year, today.month, targetDay);
        }
    }
  }
  
  /// Metodo legacy per compatibilità
  static DateTime getInitialTargetDate(DateTime now, {int targetDay = 27}) {
    return getNextTargetDate(now, BudgetPeriod.monthly, targetDay: targetDay);
  }

  /// Calcola i giorni mancanti fino al prossimo giorno target (default 27)
  static int calculateDays(DateTime now, {int targetDay = 27}) {
    final targetDate = getInitialTargetDate(now, targetDay: targetDay);
    return getDaysRemaining(now, targetDate);
  }

  /// Restituisce l'inizio della settimana (Lunedì) per una data data
  static DateTime getStartOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: date.weekday - 1));
  }

  /// Restituisce la fine della settimana (Domenica) per una data data
  static DateTime getEndOfWeek(DateTime date) {
    return getStartOfWeek(date).add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  /// Filtra le spese in un intervallo di date
  static List<Expense> getExpensesInPeriod(List<Expense> expenses, DateTime start, DateTime end) {
    return expenses.where((e) => e.date.isAfter(start.subtract(const Duration(seconds: 1))) && 
                                e.date.isBefore(end.add(const Duration(seconds: 1)))).toList();
  }

  /// Calcola il totale speso in una specifica settimana
  static double calculateWeeklyTotal(List<Expense> expenses, DateTime date) {
    final start = getStartOfWeek(date);
    final end = getEndOfWeek(date);
    return calculateTotalExpenses(getExpensesInPeriod(expenses, start, end));
  }

  /// Calcola il totale speso in un specifico mese
  static double calculateMonthlyTotal(List<Expense> expenses, DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
    return calculateTotalExpenses(getExpensesInPeriod(expenses, start, end));
  }

  /// Calcola il totale speso in un specifico anno
  static double calculateYearlyTotal(List<Expense> expenses, int year) {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year, 12, 31, 23, 59, 59);
    return calculateTotalExpenses(getExpensesInPeriod(expenses, start, end));
  }

  /// Raggruppa le spese mensili per un anno
  static Map<int, double> getMonthlyBreakdown(List<Expense> expenses, int year) {
    final Map<int, double> breakdown = {};
    for (int month = 1; month <= 12; month++) {
      breakdown[month] = calculateMonthlyTotal(expenses, DateTime(year, month));
    }
    return breakdown;
  }
}

