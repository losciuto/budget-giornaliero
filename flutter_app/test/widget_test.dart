import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_giornaliero/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:timezone/data/latest_all.dart' as tz;


void main() {
  testWidgets('Budget Giornaliero smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tz.initializeTimeZones();
    
    const MethodChannel channel = MethodChannel('dexterous.com/flutter/local_notifications');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(const BudgetApp());

    // Verify that our title is present.
    // Default test locale is usually US, so we expect English title
    expect(find.text('Daily Budget'), findsOneWidget);
    
    // Verify that we have the amount input field
    expect(find.byType(TextField), findsOneWidget);
  });
}
