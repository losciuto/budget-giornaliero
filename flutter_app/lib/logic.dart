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


class BudgetLogic {
  /// Calcola i giorni mancanti alla data target.
  static int calculateDays(DateTime currentDate, {int targetDay = 27}) {
    DateTime targetDate;
    
    if (currentDate.day > targetDay) {
      if (currentDate.month == 12) {
        targetDate = DateTime(currentDate.year + 1, 1, targetDay);
      } else {
        targetDate = DateTime(currentDate.year, currentDate.month + 1, targetDay);
      }
    } else {
      try {
        targetDate = DateTime(currentDate.year, currentDate.month, targetDay);
      } catch (e) {
        int lastDay = DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
        targetDate = DateTime(currentDate.year, currentDate.month, lastDay);
      }
    }

    final todayMidnight = DateTime(currentDate.year, currentDate.month, currentDate.day);
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
  
  /// Determina la data target iniziale basata sulla data corrente.
  static DateTime getInitialTargetDate(DateTime now, {int targetDay = 27}) {
    if (now.day > targetDay) {
      if (now.month == 12) {
        return DateTime(now.year + 1, 1, targetDay);
      } else {
        return DateTime(now.year, now.month + 1, targetDay);
      }
    } else {
      return DateTime(now.year, now.month, targetDay);
    }
  }
}

