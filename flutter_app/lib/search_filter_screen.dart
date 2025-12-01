import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'logic.dart';

class SearchFilterScreen extends StatefulWidget {
  final List<Expense> expenses;
  final String languageCode;
  final NumberFormat currencyFormat;

  const SearchFilterScreen({
    super.key,
    required this.expenses,
    required this.languageCode,
    required this.currencyFormat,
  });

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String _searchQuery = '';
  String? _selectedCategoryFilter;
  DateTimeRange? _dateRange;
  List<Expense> _filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    _filteredExpenses = widget.expenses;
  }

  void _applyFilters() {
    setState(() {
      _filteredExpenses = widget.expenses.where((expense) {
        // Filtro per ricerca testuale
        bool matchesSearch = _searchQuery.isEmpty ||
            expense.description.toLowerCase().contains(_searchQuery.toLowerCase());

        // Filtro per categoria
        bool matchesCategory = _selectedCategoryFilter == null ||
            expense.categoryId == _selectedCategoryFilter;

        // Filtro per data
        bool matchesDate = _dateRange == null ||
            (expense.date.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
                expense.date.isBefore(_dateRange!.end.add(const Duration(days: 1))));

        return matchesSearch && matchesCategory && matchesDate;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategoryFilter = null;
      _dateRange = null;
      _filteredExpenses = widget.expenses;
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', widget.languageCode);
    final totalFiltered = _filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.languageCode == 'it' ? 'Ricerca e Filtri' : 'Search & Filters'),
        backgroundColor: const Color(0xFF2196F3),
        actions: [
          if (_searchQuery.isNotEmpty || _selectedCategoryFilter != null || _dateRange != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: widget.languageCode == 'it' ? 'Cancella filtri' : 'Clear filters',
              onPressed: _clearFilters,
            ),
        ],
      ),
      body: Column(
        children: [
          // Barra di ricerca e filtri
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                // Campo di ricerca
                TextField(
                  decoration: InputDecoration(
                    hintText: widget.languageCode == 'it' ? 'Cerca per descrizione...' : 'Search by description...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 12),

                // Filtri
                Row(
                  children: [
                    // Filtro categoria
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategoryFilter,
                        decoration: InputDecoration(
                          labelText: widget.languageCode == 'it' ? 'Categoria' : 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(widget.languageCode == 'it' ? 'Tutte' : 'All'),
                          ),
                          ...ExpenseCategory.defaultCategories.map((cat) {
                            return DropdownMenuItem<String>(
                              value: cat.id,
                              child: Row(
                                children: [
                                  Icon(cat.icon, color: cat.color, size: 18),
                                  const SizedBox(width: 8),
                                  Text(cat.getName(widget.languageCode)),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryFilter = value;
                          });
                          _applyFilters();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Filtro data
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectDateRange,
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _dateRange == null
                              ? (widget.languageCode == 'it' ? 'Periodo' : 'Period')
                              : '${dateFormat.format(_dateRange!.start)} - ${dateFormat.format(_dateRange!.end)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Riepilogo risultati
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.languageCode == 'it'
                      ? '${_filteredExpenses.length} spese trovate'
                      : '${_filteredExpenses.length} expenses found',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.languageCode == 'it'
                      ? 'Totale: ${widget.currencyFormat.format(totalFiltered)}'
                      : 'Total: ${widget.currencyFormat.format(totalFiltered)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),

          // Lista risultati
          Expanded(
            child: _filteredExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          widget.languageCode == 'it'
                              ? 'Nessuna spesa trovata'
                              : 'No expenses found',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredExpenses.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final expense = _filteredExpenses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: expense.category.color.withOpacity(0.2),
                            child: Icon(
                              expense.category.icon,
                              color: expense.category.color,
                              size: 24,
                            ),
                          ),
                          title: Text(expense.description),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dateFormat.format(expense.date)),
                              Text(
                                expense.category.getName(widget.languageCode),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: expense.category.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            '- ${widget.currencyFormat.format(expense.amount)}',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
