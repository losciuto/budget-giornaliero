import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'logic.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Giornaliero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3), // Blue
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E),
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it', 'IT'),
      ],
      home: const BudgetHomeScreen(),
    );
  }
}

class BudgetHomeScreen extends StatefulWidget {
  const BudgetHomeScreen({super.key});

  @override
  State<BudgetHomeScreen> createState() => _BudgetHomeScreenState();
}

class _BudgetHomeScreenState extends State<BudgetHomeScreen> {
  late DateTime _targetDate;
  final TextEditingController _amountController = TextEditingController();
  
  String _daysRemaining = "--";
  String _dailyBudget = "€ 0.00";
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _targetDate = BudgetLogic.getInitialTargetDate(DateTime.now());
    _updateCalculations();
  }

  void _updateCalculations() {
    setState(() {
      // Calcola giorni
      final days = BudgetLogic.calculateDays(DateTime.now(), targetDay: _targetDate.day);
      
      // Se la data target è diversa dal giorno 27, la logica potrebbe dover essere adattata
      // Ma qui usiamo la data target completa selezionata dall'utente o calcolata.
      // Nota: BudgetLogic.calculateDays ricalcola un po' la logica del "mese prossimo" se si passa solo oggi.
      // Qui vogliamo calcolare la differenza esatta tra OGGI e la TARGET DATE scelta.
      
      final today = DateTime.now();
      final todayMidnight = DateTime(today.year, today.month, today.day);
      final targetMidnight = DateTime(_targetDate.year, _targetDate.month, _targetDate.day);
      
      int diff = targetMidnight.difference(todayMidnight).inDays + 1;
      
      if (targetMidnight.isBefore(todayMidnight)) {
        _daysRemaining = "Scaduto";
        diff = 0;
      } else {
        _daysRemaining = diff.toString();
      }

      // Calcola Budget
      double amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
      double daily = BudgetLogic.calculateDailyBudget(amount, diff);
      
      _dailyBudget = "€ ${daily.toStringAsFixed(2)}";
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('it', 'IT'),
    );
    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
      _updateCalculations();
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Informazioni"),
          content: const Text(
            "Autore: Massimo Lo Sciuto\n"
            "Supporto: Antigravity\n"
            "Sviluppo: Gemini 3 Pro\n"
            "Versione: 1.1.1 (Flutter)",
          ),
          actions: [
            TextButton(
              child: const Text("CHIUDI"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Budget Giornaliero",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.blue),
                      onPressed: _showInfoDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Gestione spese mensili",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Date Picker
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Data Fine Budget", style: TextStyle(color: Colors.grey)),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_today),
                            label: Text(_dateFormat.format(_targetDate)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Amount Input
                        TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: "Importo Disponibile (€)",
                            hintText: "Inserisci il tuo budget totale",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.euro),
                          ),
                          style: const TextStyle(fontSize: 20),
                          onChanged: (value) => _updateCalculations(),
                        ),
                        const SizedBox(height: 20),
                        
                        // Info Grid
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Data di Oggi", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 5),
                                  Text(
                                    _dateFormat.format(DateTime.now()),
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Giorni Mancanti", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 5),
                                  Text(
                                    _daysRemaining,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 10),
                        
                        // Result
                        const Text("Puoi spendere al giorno:", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 5),
                        Text(
                          _dailyBudget,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
