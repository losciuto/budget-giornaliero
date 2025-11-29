import 'package:flutter_test/flutter_test.dart';
import 'package:budget_giornaliero/logic.dart';

void main() {
  group('BudgetLogic Tests', () {
    test('calculateDays before target', () {
      final today = DateTime(2025, 11, 20);
      final days = BudgetLogic.calculateDays(today, targetDay: 27);
      // 20 to 27 = 8 days (inclusive)
      expect(days, 8);
    });

    test('calculateDays on target', () {
      final today = DateTime(2025, 11, 27);
      final days = BudgetLogic.calculateDays(today, targetDay: 27);
      expect(days, 1);
    });

    test('calculateDays after target (next month)', () {
      final today = DateTime(2025, 11, 28);
      final days = BudgetLogic.calculateDays(today, targetDay: 27);
      // Nov 28, 29, 30 (3 days) + 27 days in Dec = 30 days
      expect(days, 30);
    });

    test('calculateTotalExpenses', () {
      final expenses = [
        Expense(amount: 10.0, description: 'A', date: DateTime.now()),
        Expense(amount: 20.0, description: 'B', date: DateTime.now()),
      ];
      expect(BudgetLogic.calculateTotalExpenses(expenses), 30.0);
    });

    test('calculateDailyBudget', () {
      expect(BudgetLogic.calculateDailyBudget(100.0, 20.0, 4), 20.0);
      expect(BudgetLogic.calculateDailyBudget(100.0, 0.0, 4), 25.0);
      expect(BudgetLogic.calculateDailyBudget(100.0, 0.0, 0), 0.0);
    });
  });
}
