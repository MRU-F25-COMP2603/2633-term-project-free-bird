import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:free_bird/main.dart';

void main() {
  testWidgets('Home screen renders a Scaffold', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const MyApp());

    // Verify a Scaffold (page structure) is present
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
