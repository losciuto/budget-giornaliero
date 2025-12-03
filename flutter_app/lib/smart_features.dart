import 'package:flutter/material.dart';
import 'logic.dart';
import 'app_strings.dart';

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
        title: AppStrings.getSimple('smart_warning_title', languageCode),
        message: AppStrings.getSimple('smart_warning_msg', languageCode)
            .replaceAll('{percent}', ((avgDailySpending / dailyBudget - 1) * 100).toStringAsFixed(0)),
        icon: Icons.warning_amber,
        color: Colors.orange,
      ));
    } else if (avgDailySpending < dailyBudget * 0.8) {
      suggestions.add(SmartSuggestion(
        type: SuggestionType.success,
        title: AppStrings.getSimple('smart_success_title', languageCode),
        message: AppStrings.getSimple('smart_success_msg', languageCode)
            .replaceAll('{percent}', ((1 - avgDailySpending / dailyBudget) * 100).toStringAsFixed(0)),
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
        title: AppStrings.getSimple('smart_top_cat_title', languageCode),
        message: AppStrings.getSimple('smart_top_cat_msg', languageCode)
            .replaceAll('{category}', topCat.getName(languageCode))
            .replaceAll('{percent}', percentage),
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
          title: AppStrings.getSimple('smart_forecast_title', languageCode),
          message: AppStrings.getSimple('smart_forecast_msg', languageCode)
              .replaceAll('{amount}', excess.toStringAsFixed(2) + '€'),
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
        title: AppStrings.getSimple('smart_streak_title', languageCode),
        message: AppStrings.getSimple('smart_streak_msg', languageCode)
            .replaceAll('{days}', recentDaysWithoutExpenses.toString()),
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

    return SizedBox(
      height: 65,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return Container(
            width: 230,
            margin: const EdgeInsets.only(right: 8),
            child: Card(
              elevation: 2,
              color: suggestion.color.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: suggestion.color.withOpacity(0.3), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(suggestion.icon, color: suggestion.color, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            suggestion.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.5,
                              color: suggestion.color,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Expanded(
                            child: Text(
                              suggestion.message,
                              style: const TextStyle(fontSize: 9.5, height: 1.1),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
