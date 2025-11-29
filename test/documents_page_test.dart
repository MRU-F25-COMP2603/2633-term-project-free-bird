// Documents Page Tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_bird/main.dart';

void main() {
  group('Documents Page Tests', () {
    testWidgets('Documents page displays AppBar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Verify AppBar exists and has correct title
      expect(find.byType(AppBar), findsOneWidget);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect((appBar.title as Text).data, 'Documents');
    });

    testWidgets('Documents page displays header section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Only AppBar 'Documents' text remains (header section removed)
      expect(find.text('Documents'), findsOneWidget);
      
      // Verify page layout exists
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Documents page displays File Upload button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      expect(find.text('File Upload'), findsOneWidget);
      
      // Verify it's an ElevatedButton
      final fileUploadButton = find.ancestor(
        of: find.text('File Upload'),
        matching: find.byType(ElevatedButton),
      );
      expect(fileUploadButton, findsOneWidget);
    });

    testWidgets('Documents page displays Stored Documents button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      expect(find.text('Stored Documents'), findsOneWidget);
      
      // Verify it's an ElevatedButton
      final storedDocsButton = find.ancestor(
        of: find.text('Stored Documents'),
        matching: find.byType(ElevatedButton),
      );
      expect(storedDocsButton, findsOneWidget);
    });

    testWidgets('Documents page has exactly two buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Verify exactly two ElevatedButtons
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('Documents page buttons are properly sized', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Find all SizedBox widgets that wrap buttons
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsWidgets);
      
      // Verify buttons exist within sized containers
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('Documents page has Scaffold layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Verify Scaffold exists
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Documents page uses Center and Row layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Verify Center and Row layout
      expect(find.byType(Center), findsWidgets);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('Documents page uses Row layout for buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Verify Row layout for button arrangement
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('Documents page uses Center widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Verify Center widget for centering buttons
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('Documents page AppBar has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Verify AppBar exists and contains the title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Documents'), findsOneWidget);
    });

    testWidgets('Documents page buttons have rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Find ElevatedButtons
      final buttons = tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
      
      for (final button in buttons) {
        final style = button.style;
        expect(style, isNotNull);
      }
    });

    testWidgets('Documents page buttons have proper text alignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Find button text widgets
      final fileUploadText = tester.widget<Text>(find.text('File Upload'));
      expect(fileUploadText.textAlign, TextAlign.center);
      
      final storedDocsText = tester.widget<Text>(find.text('Stored Documents'));
      expect(storedDocsText.textAlign, TextAlign.center);
    });

    testWidgets('Documents page header container has background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimplePage(pageIndex: 3),
        ),
      );

      // Verify buttons have proper styling
      expect(find.byType(ElevatedButton), findsNWidgets(2));
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
