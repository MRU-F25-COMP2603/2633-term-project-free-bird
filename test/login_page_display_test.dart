import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_bird/login_page.dart';

void main() {
  testWidgets('Login page displays title, text fields, and buttons correctly', (WidgetTester tester) async {
    // Build the LoginPage inside a MaterialApp to give it proper context
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify there are two "Log in" texts (title and button)
    expect(find.text('Log in'), findsNWidgets(2));

    // Verify two TextFields exist (Email + Password)
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify "Create an Account" link exists
    expect(find.text('Create an Account'), findsOneWidget);

    // Verify the login button exists and is an ElevatedButton
    expect(find.widgetWithText(ElevatedButton, 'Log in'), findsOneWidget);
  });
}
