import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../logic.dart';
import '../app_strings.dart';

class PeriodicReportsScreen extends StatefulWidget {
  final List<Expense> expenses;
  final String languageCode;
  final NumberFormat currencyFormat;

  const PeriodicReportsScreen({
    super.key,
    required this.expenses,
    required this.languageCode,
    required this.currencyFormat,
  });

  @override
  State<PeriodicReportsScreen> createState() => _PeriodicReportsScreenState();
}

class _PeriodicReportsScreenState extends State<PeriodicReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _movePeriod(int delta) {
    setState(() {
      switch (_tabController.index) {
        case 0: // Giornaliero
          _focusedDate = _focusedDate.add(Duration(days: delta));
          break;
        case 1: // Settimanale
          _focusedDate = _focusedDate.add(Duration(days: delta * 7));
          break;
        case 2: // Mensile
          _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + delta, 1);
          break;
        case 3: // Annuale
          _focusedDate = DateTime(_focusedDate.year + delta, _focusedDate.month, 1);
          break;
      }
    });
  }

  String _getPeriodLabel() {
    switch (_tabController.index) {
      case 0: // Giornaliero
        return DateFormat.yMMMMd(widget.languageCode).format(_focusedDate);
      case 1: // Settimanale
        final start = BudgetLogic.getStartOfWeek(_focusedDate);
        final end = BudgetLogic.getEndOfWeek(_focusedDate);
        return "${DateFormat.MMMd(widget.languageCode).format(start)} - ${DateFormat.yMMMd(widget.languageCode).format(end)}";
      case 2: // Mensile
        return DateFormat.yMMMM(widget.languageCode).format(_focusedDate);
      case 3: // Annuale
        return _focusedDate.year.toString();
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(context, 'periodic_reports', languageCode: widget.languageCode)),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() {}),
          tabs: [
            Tab(text: AppStrings.get(context, 'today', languageCode: widget.languageCode)),
            Tab(text: AppStrings.get(context, 'week', languageCode: widget.languageCode)),
            Tab(text: AppStrings.get(context, 'month', languageCode: widget.languageCode)),
            Tab(text: AppStrings.get(context, 'year', languageCode: widget.languageCode)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Navigazione Periodo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _movePeriod(-1),
                  tooltip: AppStrings.get(context, 'previous', languageCode: widget.languageCode),
                ),
                Text(
                  _getPeriodLabel(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _movePeriod(1),
                  tooltip: AppStrings.get(context, 'next', languageCode: widget.languageCode),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // Disabilita swipe per evitare conflitti con grafici
              children: [
                _buildDailyTab(),
                _buildWeeklyTab(),
                _buildMonthlyTab(),
                _buildYearlyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, IconData icon, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  widget.currencyFormat.format(amount),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTab() {
    final startOfDay = DateTime(_focusedDate.year, _focusedDate.month, _focusedDate.day);
    final endOfDay = DateTime(_focusedDate.year, _focusedDate.month, _focusedDate.day, 23, 59, 59);
    final dailyExpenses = BudgetLogic.getExpensesInPeriod(widget.expenses, startOfDay, endOfDay);
    final total = BudgetLogic.calculateTotalExpenses(dailyExpenses);

    return _buildExpenseListWithTotal(dailyExpenses, total, AppStrings.get(context, 'daily_summary', languageCode: widget.languageCode));
  }

  Widget _buildWeeklyTab() {
    final start = BudgetLogic.getStartOfWeek(_focusedDate);
    final end = BudgetLogic.getEndOfWeek(_focusedDate);
    final weeklyExpenses = BudgetLogic.getExpensesInPeriod(widget.expenses, start, end);
    final total = BudgetLogic.calculateTotalExpenses(weeklyExpenses);

    // Dati per grafico a barre (7 giorni)
    final Map<int, double> dailyTotals = {};
    for (int i = 0; i < 7; i++) {
      final day = start.add(Duration(days: i));
      final dayExpenses = BudgetLogic.getExpensesInPeriod(widget.expenses, 
          DateTime(day.year, day.month, day.day), 
          DateTime(day.year, day.month, day.day, 23, 59, 59));
      dailyTotals[i] = BudgetLogic.calculateTotalExpenses(dayExpenses);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSummaryCard(AppStrings.get(context, 'weekly_summary', languageCode: widget.languageCode), total, Icons.calendar_view_week, Colors.orange),
          _buildBarChart(dailyTotals, 7, (value) {
            const weekdays = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];
            return weekdays[value.toInt()];
          }),
          _buildExpenseList(weeklyExpenses),
        ],
      ),
    );
  }

  Widget _buildMonthlyTab() {
    final start = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final end = DateTime(_focusedDate.year, _focusedDate.month + 1, 0, 23, 59, 59);
    final monthlyExpenses = BudgetLogic.getExpensesInPeriod(widget.expenses, start, end);
    final total = BudgetLogic.calculateTotalExpenses(monthlyExpenses);

    // Dati per grafico (settimane del mese)
    final Map<int, double> weeklyTotals = {};
    for (int i = 0; i < 5; i++) {
        final wStart = start.add(Duration(days: i * 7));
        if (wStart.isAfter(end)) break;
        final wEnd = wStart.add(const Duration(days: 6, hours: 23, minutes: 59));
        weeklyTotals[i] = BudgetLogic.calculateTotalExpenses(BudgetLogic.getExpensesInPeriod(widget.expenses, wStart, wEnd));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSummaryCard(AppStrings.get(context, 'monthly_summary', languageCode: widget.languageCode), total, Icons.calendar_month, Colors.blue),
          _buildBarChart(weeklyTotals, weeklyTotals.length, (value) => "S${value.toInt() + 1}"),
          _buildExpenseList(monthlyExpenses),
        ],
      ),
    );
  }

  Widget _buildYearlyTab() {
    final year = _focusedDate.year;
    final yearlyExpenses = BudgetLogic.getExpensesInPeriod(widget.expenses, DateTime(year, 1, 1), DateTime(year, 12, 31, 23, 59, 59));
    final total = BudgetLogic.calculateTotalExpenses(yearlyExpenses);
    final breakdown = BudgetLogic.getMonthlyBreakdown(widget.expenses, year);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSummaryCard(AppStrings.get(context, 'yearly_summary', languageCode: widget.languageCode), total, Icons.calendar_today, Colors.green),
          _buildBarChart( breakdown, 12, (value) {
            const months = ['G', 'F', 'M', 'A', 'M', 'G', 'L', 'A', 'S', 'O', 'N', 'D'];
            return months[value.toInt() - 1];
          }),
          _buildExpenseList(yearlyExpenses),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<dynamic, double> data, int count, String Function(double) getTitle) {
    if (data.values.every((v) => v == 0)) return const SizedBox.shrink();

    double maxY = data.values.isEmpty ? 10 : data.values.reduce((a, b) => a > b ? a : b) * 1.2;
    if (maxY == 0) maxY = 10;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barGroups: List.generate(count, (index) {
            final key = data.keys.elementAt(index);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data[key] ?? 0,
                  color: Theme.of(context).colorScheme.primary,
                  width: 12,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                )
              ],
            );
          }),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(getTitle(value), style: const TextStyle(fontSize: 10)),
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildExpenseListWithTotal(List<Expense> expenses, double total, String title) {
    return Column(
      children: [
        _buildSummaryCard(title, total, Icons.today, Colors.teal),
        Expanded(child: _buildExpenseList(expenses)),
      ],
    );
  }

  Widget _buildExpenseList(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            AppStrings.get(context, 'no_expenses', languageCode: widget.languageCode),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final category = expense.category;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: category.color.withOpacity(0.2),
            child: Icon(category.icon, color: category.color),
          ),
          title: Text(expense.description),
          subtitle: Text(DateFormat.yMMMd(widget.languageCode).format(expense.date)),
          trailing: Text(
            widget.currencyFormat.format(expense.amount),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
        );
      },
    );
  }
}
