// Translation & Currency Page Tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_bird/translation_page.dart';

void main() {
  group('Translation & Currency Page Tests', () {
    testWidgets('Translation page displays AppBar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // Verify AppBar title
      expect(find.text('Translation & Currency'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Translation page displays Translator section header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.text('Translator'), findsOneWidget);
    });

    testWidgets('Translation page has text input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // Verify translator input field exists
      expect(find.widgetWithText(TextField, 'Text to translate'), findsOneWidget);
    });

    testWidgets('Translation page displays Target language label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.text('Target:'), findsOneWidget);
    });

    testWidgets('Translation page has language dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // At least one dropdown for language selection
      expect(find.byType(DropdownButton<String>), findsWidgets);
    });

    testWidgets('Translation page has Translate button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.text('Translate'), findsOneWidget);
      
      // Verify it's an ElevatedButton
      final translateButton = find.ancestor(
        of: find.text('Translate'),
        matching: find.byType(ElevatedButton),
      );
      expect(translateButton, findsOneWidget);
    });

    testWidgets('Translation page displays Result label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.text('Result:'), findsAtLeastNWidgets(1));
    });

    testWidgets('Translation page displays Currency Converter section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.text('Currency Converter (Bank of Canada)'), findsOneWidget);
    });

    testWidgets('Currency converter has Amount input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Amount'), findsOneWidget);
    });

    testWidgets('Currency converter displays From label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.text('From'), findsOneWidget);
    });

    testWidgets('Currency converter displays To label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.text('To'), findsOneWidget);
    });

    testWidgets('Currency converter has Convert button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.text('Convert'), findsOneWidget);
      
      // Verify it's an ElevatedButton
      final convertButton = find.ancestor(
        of: find.text('Convert'),
        matching: find.byType(ElevatedButton),
      );
      expect(convertButton, findsOneWidget);
    });

    testWidgets('Translation page has two Card widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // One card for translator, one for currency
      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('Translation page is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // Verify SingleChildScrollView for scrollable content
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Translation page has three dropdowns', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // 1 for language, 2 for currencies
      expect(find.byType(DropdownButton<String>), findsNWidgets(3));
    });

    testWidgets('Translation page has two action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // Translate and Convert buttons
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('Currency amount field has numeric keyboard', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      final amountField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Amount'),
      );
      
      expect(amountField.keyboardType, const TextInputType.numberWithOptions(decimal: true));
    });

    testWidgets('Translation text field has multiline support', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      final translateField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Text to translate'),
      );
      
      // Should support multiline input
      expect(translateField.maxLines, greaterThan(1));
    });

    testWidgets('Translation page uses Column layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // Verify Column layout exists
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Translation page uses Row layout for controls', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // Verify Row layout exists for horizontal arrangements
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('Translation page has proper spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // Verify SizedBox widgets for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('Translation page has Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Translation page cards have padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // Verify Padding widgets exist within cards
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Currency converter result section exists', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TranslationPage(),
        ),
      );

      // Verify result display areas exist
      expect(find.text('Result:'), findsWidgets);
    });
  });
}
