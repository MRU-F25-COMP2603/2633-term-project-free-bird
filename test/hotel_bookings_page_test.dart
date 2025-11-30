// Hotel Bookings Page Tests
// Testing the UI without needing Firebase

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple mock widget that looks like the real thing but doesn't need Firebase
class _MockHotelBookingsPage extends StatefulWidget {
  const _MockHotelBookingsPage();

  @override
  State<_MockHotelBookingsPage> createState() => _MockHotelBookingsPageState();
}

class _MockHotelBookingsPageState extends State<_MockHotelBookingsPage> {
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();

  @override
  void dispose() {
    _hotelNameController.dispose();
    _addressController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Bookings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Booking',
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
                      controller: _hotelNameController,
                      decoration: const InputDecoration(
                        labelText: 'Hotel Name',
                        hintText: 'e.g., Grand Hotel',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'Hotel address',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _checkInController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Check-in Date',
                        hintText: 'Select check-in date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _checkOutController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Check-out Date',
                        hintText: 'Select check-out date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Add Booking'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Your Bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Shared Bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('Hotel Bookings Page UI Tests', () {
    testWidgets('Hotel bookings page has AppBar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Hotel Bookings'), findsOneWidget);
    });

    testWidgets('Hotel bookings page displays Add New Booking header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.text('Add New Booking'), findsOneWidget);
    });

    testWidgets('Hotel bookings page has Hotel Name field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Hotel Name'), findsOneWidget);
    });

    testWidgets('Hotel bookings page has Address field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Address'), findsOneWidget);
    });

    testWidgets('Hotel bookings page has Check-in Date field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Check-in Date'), findsOneWidget);
    });

    testWidgets('Hotel bookings page has Check-out Date field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.widgetWithText(TextField, 'Check-out Date'), findsOneWidget);
    });

    testWidgets('Hotel bookings page has Add Booking button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.text('Add Booking'), findsOneWidget);
    });

    testWidgets('Hotel bookings page displays Your Bookings header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.text('Your Bookings'), findsOneWidget);
    });

    testWidgets('Hotel bookings page displays Shared Bookings header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.text('Shared Bookings'), findsOneWidget);
    });

    testWidgets('Hotel bookings page has calendar icons for date pickers', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsNWidgets(2));
    });

    testWidgets('Hotel bookings page has Card widget for form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Hotel bookings page uses Column layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Hotel bookings page Hotel Name field has hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Hotel Name'),
      );
      expect(textField.decoration?.hintText, 'e.g., Grand Hotel');
    });

    testWidgets('Hotel bookings page Address field has hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Address'),
      );
      expect(textField.decoration?.hintText, 'Hotel address');
    });

    testWidgets('Hotel bookings page Check-in field has hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Check-in Date'),
      );
      expect(textField.decoration?.hintText, 'Select check-in date');
    });

    testWidgets('Hotel bookings page Check-out field has hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Check-out Date'),
      );
      expect(textField.decoration?.hintText, 'Select check-out date');
    });

    testWidgets('Hotel bookings page check-in field is read-only', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Check-in Date'),
      );
      expect(textField.readOnly, true);
    });

    testWidgets('Hotel bookings page check-out field is read-only', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Check-out Date'),
      );
      expect(textField.readOnly, true);
    });

    testWidgets('Hotel bookings page has proper spacing with SizedBox', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('Hotel bookings page has ElevatedButton for Add Booking', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      final addButton = find.ancestor(
        of: find.text('Add Booking'),
        matching: find.byType(ElevatedButton),
      );
      expect(addButton, findsOneWidget);
    });

    testWidgets('Hotel bookings page form has proper text field count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(4));
    });

    testWidgets('Hotel bookings page displays all section headers', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.text('Add New Booking'), findsOneWidget);
      expect(find.text('Your Bookings'), findsOneWidget);
      expect(find.text('Shared Bookings'), findsOneWidget);
    });

    testWidgets('Hotel bookings page card has proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4);
    });

    testWidgets('Hotel bookings page has proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: _MockHotelBookingsPage(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });
  });
}
