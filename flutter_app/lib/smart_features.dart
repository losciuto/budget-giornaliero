import 'package:flutter/material.dart';
import 'logic.dart';

class SmartFeatures {
  /// Analizza i pattern di spesa e genera suggerimenti
  static List<SmartSuggestion> generateSuggestions({
    required List<Expense> expenses,
    required double totalBudget,
    required double dailyBudget,
    required int daysRemaining,
    required String languageCode,
  }) {
    final suggestions = <SmartSuggestion>[];
    
    if (expenses.isEmpty) return suggestions;

    // Calcola spesa media giornaliera
    final totalSpent = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final daysWithExpenses = _getDaysWithExpenses(expenses);
    final avgDailySpending = daysWithExpenses > 0 ? totalSpent / daysWithExpenses : 0;

    // Suggerimento 1: Confronto spesa media vs budget giornaliero
    if (avgDailySpending > dailyBudget * 1.2) {
      suggestions.add(SmartSuggestion(
        type: SuggestionType.warning,
        title: languageCode == 'it' ? 'Attenzione!' : 'Warning!',
        message: languageCode == 'it'
            ? 'Stai spendendo il ${((avgDailySpending / dailyBudget - 1) * 100).toStringAsFixed(0)}% in più del budget giornaliero'
            : 'You are spending ${((avgDailySpending / dailyBudget - 1) * 100).toStringAsFixed(0)}% more than daily budget',
        icon: Icons.warning_amber,
        color: Colors.orange,
      ));
    } else if (avgDailySpending < dailyBudget * 0.8) {
      suggestions.add(SmartSuggestion(
        type: SuggestionType.success,
        title: languageCode == 'it' ? 'Ottimo lavoro!' : 'Great job!',
        message: languageCode == 'it'
            ? 'Stai risparmiando! Spesa media sotto il budget del ${((1 - avgDailySpending / dailyBudget) * 100).toStringAsFixed(0)}%'
            : 'You are saving! Average spending below budget by ${((1 - avgDailySpending / dailyBudget) * 100).toStringAsFixed(0)}%',
        icon: Icons.trending_down,
        color: Colors.green,
      ));
    }

    // Suggerimento 2: Categoria con più spese
    final categoryExpenses = _groupByCategory(expenses);
    if (categoryExpenses.isNotEmpty) {
      final topCategory = categoryExpenses.entries.reduce((a, b) => a.value > b.value ? a : b);
      final topCat = ExpenseCategory.findById(topCategory.key) ?? ExpenseCategory.defaultCategories.last;
      final percentage = (topCategory.value / totalSpent * 100).toStringAsFixed(0);
      
      suggestions.add(SmartSuggestion(
        type: SuggestionType.info,
        title: languageCode == 'it' ? 'Categoria principale' : 'Top Category',
        message: languageCode == 'it'
            ? '${topCat.nameIt}: $percentage% delle spese totali'
            : '${topCat.nameEn}: $percentage% of total expenses',
        icon: topCat.icon,
        color: topCat.color,
      ));
    }

    // Suggerimento 3: Previsione fine periodo
    if (daysRemaining > 0 && avgDailySpending > 0) {
      final projectedTotal = totalSpent + (avgDailySpending * daysRemaining);
      if (projectedTotal > totalBudget) {
        final excess = projectedTotal - totalBudget;
        suggestions.add(SmartSuggestion(
          type: SuggestionType.warning,
          title: languageCode == 'it' ? 'Previsione Budget' : 'Budget Forecast',
          message: languageCode == 'it'
              ? 'Al ritmo attuale, supererai il budget di ${excess.toStringAsFixed(2)}€'
              : 'At current rate, you will exceed budget by ${excess.toStringAsFixed(2)}€',
          icon: Icons.trending_up,
          color: Colors.red,
        ));
      }
    }

    // Suggerimento 4: Giorni senza spese
    final recentDaysWithoutExpenses = _getRecentDaysWithoutExpenses(expenses);
    if (recentDaysWithoutExpenses >= 3) {
      suggestions.add(SmartSuggestion(
        type: SuggestionType.success,
        title: languageCode == 'it' ? 'Streak di risparmio!' : 'Saving Streak!',
        message: languageCode == 'it'
            ? '$recentDaysWithoutExpenses giorni senza spese!'
            : '$recentDaysWithoutExpenses days without expenses!',
        icon: Icons.emoji_events,
        color: Colors.amber,
      ));
    }

    return suggestions;
  }

  static int _getDaysWithExpenses(List<Expense> expenses) {
    final uniqueDays = expenses.map((e) => DateTime(e.date.year, e.date.month, e.date.day)).toSet();
    return uniqueDays.length;
  }

  static Map<String, double> _groupByCategory(List<Expense> expenses) {
    final map = <String, double>{};
    for (var expense in expenses) {
      final catId = expense.categoryId ?? 'other';
      map[catId] = (map[catId] ?? 0) + expense.amount;
    }
    return map;
  }

  static int _getRecentDaysWithoutExpenses(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    int streak = 0;
    for (int i = 0; i < 30; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final hasExpense = expenses.any((e) {
        final expenseDate = DateTime(e.date.year, e.date.month, e.date.day);
        return expenseDate.isAtSameMomentAs(checkDate);
      });
      
      if (hasExpense) break;
      streak++;
    }
    
    return streak;
  }
}

enum SuggestionType {
  info,
  warning,
  success,
}

class SmartSuggestion {
  final SuggestionType type;
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  SmartSuggestion({
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });
}

/// Widget per visualizzare i suggerimenti smart
class SmartSuggestionsWidget extends StatelessWidget {
  final List<SmartSuggestion> suggestions;

  const SmartSuggestionsWidget({
    super.key,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: suggestions.map((suggestion) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: suggestion.color.withOpacity(0.1),
          child: ListTile(
            leading: Icon(suggestion.icon, color: suggestion.color, size: 32),
            title: Text(
              suggestion.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: suggestion.color,
              ),
            ),
            subtitle: Text(suggestion.message),
          ),
        );
      }).toList(),
    );
  }
}
