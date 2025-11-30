// SimplePage Routing Tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_bird/main.dart';

void main() {
  group('SimplePage Routing Tests', () {
    testWidgets('SimplePage creates correct widget for index 3', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Should show Documents page (AppBar only - header was removed)
      expect(find.text('Documents'), findsOneWidget);
    });

    testWidgets('SimplePage shows Documents page content for index 3', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      expect(find.text('File Upload'), findsOneWidget);
      expect(find.text('Stored Documents'), findsOneWidget);
    });

    testWidgets('SimplePage creates correct widget for index 4', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 4),
        ),
      );

      // Should show Translation page
      expect(find.text('Translation & Currency'), findsOneWidget);
    });

    testWidgets('SimplePage shows Translation page content for index 4', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 4),
        ),
      );

      expect(find.text('Translator'), findsOneWidget);
      expect(find.text('Currency Converter (Bank of Canada)'), findsOneWidget);
    });

    testWidgets('SimplePage accepts pageIndex parameter', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      final simplePage = tester.widget<SimplePage>(find.byType(SimplePage));
      expect(simplePage.pageIndex, 3);
    });

    testWidgets('SimplePage with index 3 has correct AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Documents'), findsWidgets);
    });

    testWidgets('SimplePage with index 4 has correct AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 4),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Translation & Currency'), findsOneWidget);
    });

    testWidgets('SimplePage maintains pageIndex value', (WidgetTester tester) async {
      const testIndex = 4;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: testIndex),
        ),
      );

      final simplePage = tester.widget<SimplePage>(find.byType(SimplePage));
      expect(simplePage.pageIndex, testIndex);
    });

    testWidgets('SimplePage renders Scaffold for index 3', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('SimplePage renders Scaffold for index 4', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 4),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
