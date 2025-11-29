import 'package:flutter/material.dart';


class Expense {
  final double amount;
  final String description;
  final DateTime date;

  Expense({required this.amount, required this.description, required this.date});

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        amount: json['amount'],
        description: json['description'],
        date: DateTime.parse(json['date']),
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

