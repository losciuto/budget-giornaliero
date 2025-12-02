import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'logic.dart';
import 'app_strings.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;
  final String languageCode;
  final String currencySymbol;
  final NumberFormat currencyFormat;

  const StatisticsScreen({
    super.key,
    required this.expenses,
    required this.languageCode,
    required this.currencySymbol,
    required this.currencyFormat,
  });

  Map<String, double> _getCategoryTotals() {
    final Map<String, double> totals = {};
    
    for (var expense in expenses) {
      final categoryId = expense.categoryId ?? 'other';
      totals[categoryId] = (totals[categoryId] ?? 0) + expense.amount;
    }
    
    return totals;
  }

  List<PieChartSectionData> _getPieChartSections() {
    final categoryTotals = _getCategoryTotals();
    final total = categoryTotals.values.fold(0.0, (sum, value) => sum + value);
    
    if (total == 0) return [];
    
    final List<PieChartSectionData> sections = [];
    
    for (final entry in categoryTotals.entries) {
      final categoryId = entry.key;
      final amount = entry.value;
      final category = ExpenseCategory.findById(categoryId) ?? 
                      ExpenseCategory.defaultCategories.last;
      final percentage = (amount / total * 100);
      
      sections.add(
        PieChartSectionData(
          color: category.color,
          value: amount,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    
    return sections;
  }

  List<BarChartGroupData> _getBarChartData() {
    final categoryTotals = _getCategoryTotals();
    final List<BarChartGroupData> barGroups = [];
    
    for (int i = 0; i < ExpenseCategory.defaultCategories.length; i++) {
      final category = ExpenseCategory.defaultCategories[i];
      final amount = categoryTotals[category.id] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: amount,
              color: category.color,
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }
    
    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _getCategoryTotals();
    final totalSpent = categoryTotals.values.fold(0.0, (sum, value) => sum + value);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(context, 'statistics', languageCode: languageCode)),
        backgroundColor: const Color(0xFF2196F3),
      ),
      body: expenses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pie_chart_outline, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.get(context, 'no_stats_data', languageCode: languageCode),
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Riepilogo Totale
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.get(context, 'spent', languageCode: languageCode),
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currencyFormat.format(totalSpent),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.account_balance_wallet, size: 60, color: Colors.blue[300]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Grafico a Torta
                  Text(
                    AppStrings.get(context, 'expenses_by_category', languageCode: languageCode),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: _getPieChartSections(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Legenda
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ExpenseCategory.defaultCategories.map((category) {
                          final amount = categoryTotals[category.id] ?? 0;
                          if (amount == 0) return const SizedBox.shrink();
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(category.icon, color: category.color, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    category.getName(languageCode),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Text(
                                  currencyFormat.format(amount),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Grafico a Barre
                  Text(
                    AppStrings.get(context, 'category_comparison', languageCode: languageCode),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 300,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: categoryTotals.values.isEmpty 
                                ? 100 
                                : categoryTotals.values.reduce((a, b) => a > b ? a : b) * 1.2,
                            barGroups: _getBarChartData(),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= 0 && 
                                        value.toInt() < ExpenseCategory.defaultCategories.length) {
                                      final category = ExpenseCategory.defaultCategories[value.toInt()];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Icon(category.icon, size: 20, color: category.color),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(
                              show: true,
                              drawVerticalLine: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
