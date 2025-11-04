import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_bird/create_account_page.dart';

void main() {
  testWidgets('CreateAccountPage displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: CreateAccountPage()));

    // Verify that the create account page displays the correct elements.
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Already have an account? Log in'), findsOneWidget);
    
    // Verify the create account button exists
    expect(find.widgetWithText(ElevatedButton, 'Create Account'), findsOneWidget);
  });

  testWidgets('CreateAccountPage shows error for mismatched passwords', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: CreateAccountPage()));

    // Enter different passwords
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.enterText(find.byType(TextField).at(2), 'password456');

    // Tap the create account button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await tester.pump();

    // Verify that an error message is shown for mismatched passwords
    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  testWidgets('CreateAccountPage shows error for short password', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: CreateAccountPage()));

    // Enter a short password
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), '123');
    await tester.enterText(find.byType(TextField).at(2), '123');

    // Tap the create account button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await tester.pump();

    // Verify that an error message is shown for short password
    expect(find.text('Password must be at least 6 characters long.'), findsOneWidget);
  });
}