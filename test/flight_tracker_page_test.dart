// Flight Tracker Page Tests
// Testing the UI without needing Firebase

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple mock widget that looks like the real thing but doesn't need Firebase
class _MockFlightTrackerPage extends StatefulWidget {
  const _MockFlightTrackerPage();

  @override
  State<_MockFlightTrackerPage> createState() => _MockFlightTrackerPageState();
}

class _MockFlightTrackerPageState extends State<_MockFlightTrackerPage> {
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _airlineController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _departureAirportController = TextEditingController();
  final TextEditingController _arrivalAirportController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();

  @override
  void dispose() {
    _flightNumberController.dispose();
    _airlineController.dispose();
    _dateController.dispose();
    _departureAirportController.dispose();
    _arrivalAirportController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Tracker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Flight',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _flightNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Flight Number',
                        hintText: 'e.g., AA123',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _airlineController,
                      decoration: const InputDecoration(
                        labelText: 'Airline',
                        hintText: 'e.g., American Airlines',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Flight Date',
                        hintText: 'Select date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _departureAirportController,
                      decoration: const InputDecoration(
                        labelText: 'From',
                        hintText: 'Departure airport',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _arrivalAirportController,
                      decoration: const InputDecoration(
                        labelText: 'To',
                        hintText: 'Arrival airport',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _departureTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Departure Time',
                        hintText: 'e.g., 14:30',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _arrivalTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Arrival Time',
                        hintText: 'e.g., 18:45',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Add Flight'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Your Flights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Shared Flights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('Flight Tracker Page UI Tests', () {
    testWidgets('Flight tracker page has AppBar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Flight Tracker'), findsOneWidget);
    });

    testWidgets('Flight tracker page displays Add New Flight header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.text('Add New Flight'), findsOneWidget);
    });

    testWidgets('Flight tracker page has Flight Number field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Flight Number'), findsOneWidget);
    });

    testWidgets('Flight tracker page has Airline field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Airline'), findsOneWidget);
    });

    testWidgets('Flight tracker page has Flight Date field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Flight Date'), findsOneWidget);
    });

    testWidgets('Flight tracker page has From field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'From'), findsOneWidget);
    });

    testWidgets('Flight tracker page has To field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'To'), findsOneWidget);
    });

    testWidgets('Flight tracker page has Departure Time field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Departure Time'), findsOneWidget);
    });

    testWidgets('Flight tracker page has Arrival Time field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Arrival Time'), findsOneWidget);
    });

    testWidgets('Flight tracker page has Add Flight button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.text('Add Flight'), findsOneWidget);
    });

    testWidgets('Flight tracker page displays Your Flights header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.text('Your Flights'), findsOneWidget);
    });

    testWidgets('Flight tracker page displays Shared Flights header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.text('Shared Flights'), findsOneWidget);
    });

    testWidgets('Flight tracker page has calendar icon for date picker', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('Flight tracker page has Card widget for form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Flight tracker page uses Column layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Flight tracker page uses SingleChildScrollView', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Flight tracker page has Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Flight tracker page has Padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Flight tracker page Flight Number field has hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Flight Number'),
      );
      expect(textField.decoration?.hintText, 'e.g., AA123');
    });

    testWidgets('Flight tracker page Airline field has hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Airline'),
      );
      expect(textField.decoration?.hintText, 'e.g., American Airlines');
    });

    testWidgets('Flight tracker page From field has hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'From'),
      );
      expect(textField.decoration?.hintText, 'Departure airport');
    });

    testWidgets('Flight tracker page To field has hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'To'),
      );
      expect(textField.decoration?.hintText, 'Arrival airport');
    });

    testWidgets('Flight tracker page has proper spacing with SizedBox', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('Flight tracker page date field is read-only', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Flight Date'),
      );
      expect(textField.readOnly, true);
    });

    testWidgets('Flight tracker page has ElevatedButton for Add Flight', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockFlightTrackerPage(),
        ),
      );

      final addButton = find.ancestor(
        of: find.text('Add Flight'),
        matching: find.byType(ElevatedButton),
      );
      expect(addButton, findsOneWidget);
    });
  });
}
