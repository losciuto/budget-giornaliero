import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../logic.dart';

/// Service for exporting budget data to Excel format
class ExcelService {
  /// Export budget data to an Excel file
  /// Returns the file path on success, null on failure
  static Future<String?> exportToExcel({
    required List<Expense> expenses,
    required double totalBudget,
    required double totalSpent,
    required double calculatedDaily,
    required String daysRemaining,
    required DateTime targetDate,
    required DateFormat dateFormat,
  }) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Budget'];

      // Define styles
      final headerStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#2196F3'),
        fontColorHex: ExcelColor.white,
        fontSize: 14,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );

      final labelStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#E3F2FD'),
      );

      final currencyStyle = CellStyle(
        numberFormat: NumFormat.standard_2,
      );

      final positiveStyle = CellStyle(
        numberFormat: NumFormat.standard_2,
        fontColorHex: ExcelColor.fromHexString('#4CAF50'),
      );

      final negativeStyle = CellStyle(
        numberFormat: NumFormat.standard_2,
        fontColorHex: ExcelColor.fromHexString('#F44336'),
      );

      final expenseHeaderStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#90CAF9'),
        horizontalAlign: HorizontalAlign.Center,
      );

      // Summary section
      sheet.appendRow([TextCellValue('RIEPILOGO BUDGET')]);
      sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('D1'));
      sheet.cell(CellIndex.indexByString('A1')).cellStyle = headerStyle;
      sheet.setRowHeight(0, 25);
      
      final remaining = totalBudget - totalSpent;
      
      sheet.appendRow([TextCellValue('Budget Totale'), DoubleCellValue(totalBudget)]);
      sheet.cell(CellIndex.indexByString('A2')).cellStyle = labelStyle;
      sheet.cell(CellIndex.indexByString('B2')).cellStyle = currencyStyle;
      
      sheet.appendRow([TextCellValue('Totale Speso'), DoubleCellValue(totalSpent)]);
      sheet.cell(CellIndex.indexByString('A3')).cellStyle = labelStyle;
      sheet.cell(CellIndex.indexByString('B3')).cellStyle = negativeStyle;
      
      sheet.appendRow([TextCellValue('Rimanente'), DoubleCellValue(remaining)]);
      sheet.cell(CellIndex.indexByString('A4')).cellStyle = labelStyle;
      sheet.cell(CellIndex.indexByString('B4')).cellStyle = remaining >= 0 ? positiveStyle : negativeStyle;
      
      sheet.appendRow([TextCellValue('Budget Giornaliero'), DoubleCellValue(calculatedDaily)]);
      sheet.cell(CellIndex.indexByString('A5')).cellStyle = labelStyle;
      sheet.cell(CellIndex.indexByString('B5')).cellStyle = currencyStyle;
      
      sheet.appendRow([TextCellValue('Giorni Mancanti'), TextCellValue(daysRemaining)]);
      sheet.cell(CellIndex.indexByString('A6')).cellStyle = labelStyle;
      
      sheet.appendRow([TextCellValue('Data Target'), TextCellValue(dateFormat.format(targetDate))]);
      sheet.cell(CellIndex.indexByString('A7')).cellStyle = labelStyle;
      
      sheet.appendRow([]);

      // Expenses section
      sheet.appendRow([TextCellValue('SPESE')]);
      sheet.merge(CellIndex.indexByString('A9'), CellIndex.indexByString('D9'));
      sheet.cell(CellIndex.indexByString('A9')).cellStyle = headerStyle;
      sheet.setRowHeight(8, 25);
      
      sheet.appendRow([TextCellValue('Data'), TextCellValue('Descrizione'), TextCellValue('Importo'), TextCellValue('Rimanente')]);
      for (int col = 0; col < 4; col++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 9)).cellStyle = expenseHeaderStyle;
      }
      
      // Sort expenses chronologically for the report (Oldest -> Newest)
      final sortedExpenses = List<Expense>.from(expenses)..sort((a, b) => a.date.compareTo(b.date));

      double runningBalance = totalBudget;
      int rowIndex = 10;
      for (var expense in sortedExpenses) {
        runningBalance -= expense.amount;
        sheet.appendRow([
          TextCellValue(dateFormat.format(expense.date)),
          TextCellValue(expense.description),
          DoubleCellValue(expense.amount),
          DoubleCellValue(runningBalance),
        ]);
        
        // Apply styles
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).cellStyle = negativeStyle;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex)).cellStyle = 
            runningBalance >= 0 ? positiveStyle : negativeStyle;
        rowIndex++;
      }

      // Set column widths
      sheet.setColumnWidth(0, 15);  // Data
      sheet.setColumnWidth(1, 30);  // Descrizione
      sheet.setColumnWidth(2, 12);  // Importo
      sheet.setColumnWidth(3, 12);  // Rimanente

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/budget_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final fileBytes = excel.save();
      
      if (fileBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);
        return filePath;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}
