import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_bird/main.dart';

void main() {
  testWidgets('App builds a MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
