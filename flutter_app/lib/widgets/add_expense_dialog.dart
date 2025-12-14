import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_strings.dart';
import '../logic.dart';
import '../receipt_scanner.dart';

/// Dialog for adding a new expense
class AddExpenseDialog extends StatefulWidget {
  final String languageCode;
  final Function(Expense) onExpenseAdded;

  const AddExpenseDialog({
    super.key,
    required this.languageCode,
    required this.onExpenseAdded,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategoryId = 'other';

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleReceiptScan() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppStrings.get(context, 'camera', languageCode: widget.languageCode)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppStrings.get(context, 'gallery', languageCode: widget.languageCode)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${AppStrings.get(context, 'scan_tooltip', languageCode: widget.languageCode)}...'), 
        duration: const Duration(seconds: 1)
      ));
      
      final amount = await ReceiptScanner.scanReceipt(source);
      
      if (!mounted) return;
      if (amount != null) {
        String formatted = amount.toStringAsFixed(2);
        _amountController.text = formatted;
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppStrings.get(context, 'amount_found', languageCode: widget.languageCode)
              .replaceAll('{amount}', formatted)),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppStrings.get(context, 'no_amount_found', languageCode: widget.languageCode)),
          backgroundColor: Colors.orange,
        ));
      }
    }
  }

  void _addExpense() {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount != null && amount > 0) {
      final expense = Expense(
        amount: amount,
        description: _descController.text.isEmpty ? 'Spesa' : _descController.text,
        date: DateTime.now(),
        categoryId: _selectedCategoryId,
      );
      widget.onExpenseAdded(expense);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.get(context, 'add_expense', languageCode: widget.languageCode)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: AppStrings.get(context, 'description', languageCode: widget.languageCode),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: AppStrings.get(context, 'amount', languageCode: widget.languageCode),
              suffixIcon: (Platform.isAndroid || Platform.isIOS)
                  ? IconButton(
                      icon: const Icon(Icons.camera_alt),
                      tooltip: AppStrings.get(context, 'scan_tooltip', languageCode: widget.languageCode),
                      onPressed: _handleReceiptScan,
                    )
                  : null,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategoryId,
            decoration: InputDecoration(
              labelText: AppStrings.get(context, 'category', languageCode: widget.languageCode),
              border: const OutlineInputBorder(),
            ),
            items: ExpenseCategory.defaultCategories.map((category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Row(
                  children: [
                    Icon(category.icon, color: category.color, size: 20),
                    const SizedBox(width: 12),
                    Text(category.getName(widget.languageCode)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCategoryId = value;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.get(context, 'cancel', languageCode: widget.languageCode)),
        ),
        ElevatedButton(
          onPressed: _addExpense,
          child: Text(AppStrings.get(context, 'add', languageCode: widget.languageCode)),
        ),
      ],
    );
  }
}
