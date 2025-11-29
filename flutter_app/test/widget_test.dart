import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_giornaliero/main.dart';

void main() {
  testWidgets('Budget Giornaliero smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BudgetApp());

    // Verify that our title is present.
    expect(find.text('Budget Giornaliero'), findsOneWidget);
    
    // Verify that we have the amount input field
    expect(find.byType(TextField), findsOneWidget);
  });
}
