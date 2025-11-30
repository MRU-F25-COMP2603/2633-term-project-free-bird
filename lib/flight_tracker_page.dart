import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_bird/weather_service.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'language_provider.dart';
import 'translations.dart';

/// ------------------------------------------------------------
///  WEATHER + MAP WIDGETS
/// ------------------------------------------------------------

class WeatherCard extends StatelessWidget {
  final String title;
  final String location;
  final String temp;
  final String condition;

  const WeatherCard({
    super.key,
    required this.title,
    required this.location,
    required this.temp,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(location, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text("$temp • $condition",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class MapCard extends StatelessWidget {
  const MapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: const Center(
        child: Icon(Icons.map, size: 70, color: Colors.blueAccent),
      ),
    );
  }
}

/// ------------------------------------------------------------
///  NEW FLIGHT OVERVIEW CARD — TICKET STYLE
/// ------------------------------------------------------------

class FlightOverviewCard extends StatelessWidget {
  final String airline;
  final String flightNumber;
  final String from;
  final String to;
  final String startDate;
  final String endDate;
  final String departureTime;
  final String arrivalTime;

  const FlightOverviewCard({
    super.key,
    required this.airline,
    required this.flightNumber,
    required this.from,
    required this.to,
    required this.startDate,
    required this.endDate,
    required this.departureTime,
    required this.arrivalTime,
  });

  static final _rand = Random();
  static const _statuses = ["ON TIME", "DELAYED", "BOARDING"];

  Color _statusColor(String status) {
    switch (status) {
      case "DELAYED":
        return Colors.orange;
      case "BOARDING":
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _statuses[_rand.nextInt(_statuses.length)];
    final gate = _rand.nextInt(40) + 1;
    final terminal = ["A", "B", "C"][_rand.nextInt(3)];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW — Airline + flight number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(airline,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(flightNumber,
                  style: const TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),

          const SizedBox(height: 10),

          /// ROUTE: YYC —— ✈ —— YYZ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(from,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 2,
                    color: Colors.blue),
              ),
              const Icon(Icons.flight, color: Colors.blue),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 2,
                    color: Colors.blue),
              ),
              Text(to,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),

          const SizedBox(height: 10),

          /// DATES + TIMES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Departure",
                        style: TextStyle(color: Colors.black54)),
                    Text("$startDate   $departureTime",
                        style: const TextStyle(fontSize: 16)),
                  ]),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Arrival",
                        style: TextStyle(color: Colors.black54)),
                    Text("$endDate   $arrivalTime",
                        style: const TextStyle(fontSize: 16)),
                  ]),
            ],
          ),

          const SizedBox(height: 10),

          /// STATUS + GATE + TERMINAL
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(status,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Text("Gate: $gate"),
              const SizedBox(width: 16),
              Text("Terminal: $terminal"),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------
///  MAIN PAGE
/// ------------------------------------------------------------

class FlightInputPage extends StatefulWidget {
  const FlightInputPage({super.key});

  @override
  State<FlightInputPage> createState() => _FlightInputPageState();
}

class _FlightInputPageState extends State<FlightInputPage> {
  final _flightNumberController = TextEditingController();
  final _airlineController = TextEditingController();
  final _dateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _departureAirportController = TextEditingController();
  final _arrivalAirportController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _arrivalTimeController = TextEditingController();

  final WeatherService weatherService = WeatherService();
  WeatherData? localWeather;
  WeatherData? destinationWeather;

  DateTime? _selectedDate;
  DateTime? _selectedEndDate;

  bool _isAddingFlight = false;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    localWeather = await weatherService.getWeatherByAirport("YYC");
    destinationWeather = await weatherService.getWeatherByAirport("YYZ");
    setState(() {});
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    _airlineController.dispose();
    _dateController.dispose();
    _endDateController.dispose();
    _departureAirportController.dispose();
    _arrivalAirportController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    super.dispose();
  }

  /// ------------------------------------------------------------
  /// DATE PICKERS
  /// ------------------------------------------------------------

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: _selectedDate ?? DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  /// ------------------------------------------------------------
  /// ADD FLIGHT
  /// ------------------------------------------------------------

  Future<void> _addFlight() async {
    final language = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
    final flightNumber = _flightNumberController.text.trim().toUpperCase();
    final airline = _airlineController.text.trim();
    final startDate = _dateController.text.trim();
    final endDate = _endDateController.text.trim();
    final departureAirport = _departureAirportController.text.trim();
    final arrivalAirport = _arrivalAirportController.text.trim();
    final departureTime = _departureTimeController.text.trim();
    final arrivalTime = _arrivalTimeController.text.trim();

    if (flightNumber.isEmpty ||
        airline.isEmpty ||
        startDate.isEmpty ||
        endDate.isEmpty ||
        departureAirport.isEmpty ||
        arrivalAirport.isEmpty ||
        departureTime.isEmpty ||
        arrivalTime.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppTranslations.get('please_fill_all_fields', language))));
      return;
    }

    setState(() => _isAddingFlight = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Not logged in");

      await FirebaseFirestore.instance.collection("flights").add({
        'userId': user.uid,
        'ownerEmail': user.email ?? "",
        'sharedWith': <String>[],
        'flightNumber': flightNumber,
        'airline': airline,
        'startDate': startDate,
        'endDate': endDate,
        'departureAirport': departureAirport,
        'arrivalAirport': arrivalAirport,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'addedAt': FieldValue.serverTimestamp(),
      });

      _flightNumberController.clear();
      _airlineController.clear();
      _dateController.clear();
      _endDateController.clear();
      _departureAirportController.clear();
      _arrivalAirportController.clear();
      _departureTimeController.clear();
      _arrivalTimeController.clear();

      _selectedDate = null;
      _selectedEndDate = null;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppTranslations.get('flight_added', language)),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }

    setState(() => _isAddingFlight = false);
  }

  /// ------------------------------------------------------------
  /// BUILD UI
  /// ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<LanguageProvider>(context).currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('flight_tracker', language)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// ------------------------------------------------------------
            /// ADD NEW FLIGHT FORM
            /// ------------------------------------------------------------

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(AppTranslations.get('add_new_flight', language),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _flightNumberController,
                            decoration: InputDecoration(
                              labelText: AppTranslations.get('flight_number', language),
                              border: const OutlineInputBorder(),
                              hintText: 'AA123',
                            ),
                            textCapitalization: TextCapitalization.characters,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _airlineController,
                            decoration: InputDecoration(
                              labelText: AppTranslations.get('airline', language),
                              border: const OutlineInputBorder(),
                              hintText: 'Air Canada',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: AppTranslations.get('start_date', language),
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: _selectStartDate,
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _endDateController,
                      decoration: InputDecoration(
                        labelText: AppTranslations.get('end_date', language),
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: _selectEndDate,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _departureAirportController,
                            decoration: InputDecoration(
                              labelText: AppTranslations.get('from', language),
                              border: const OutlineInputBorder(),
                              hintText: 'YYC',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _arrivalAirportController,
                            decoration: InputDecoration(
                              labelText: AppTranslations.get('to', language),
                              border: const OutlineInputBorder(),
                              hintText: 'YYZ',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _departureTimeController,
                            decoration: InputDecoration(
                              labelText: AppTranslations.get('departure_time', language),
                              border: const OutlineInputBorder(),
                              hintText: '08:30',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _arrivalTimeController,
                            decoration: InputDecoration(
                              labelText: AppTranslations.get('arrival_time', language),
                              border: const OutlineInputBorder(),
                              hintText: '11:45',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: _isAddingFlight ? null : _addFlight,
                      child: _isAddingFlight
                          ? const CircularProgressIndicator(strokeWidth: 2)
                          : Text(AppTranslations.get('add_flight', language)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ------------------------------------------------------------
            /// YOUR FLIGHTS
            /// ------------------------------------------------------------

            Text(AppTranslations.get('your_flights', language),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('flights')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        AppTranslations.get('no_flights', language),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  /// ---- LIST VIEW ----
                  return ListView.builder(
                    itemCount: docs.length + 1, // +1 for overview section
                    itemBuilder: (context, index) {
                      /// ---- OVERVIEW SECTION ----
                      if (index == docs.length) {
                        final f = docs.first.data() as Map<String, dynamic>;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              AppTranslations.get('flight_overview', language),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),

                            /// → TICKET CARD
                            FlightOverviewCard(
                              airline: f['airline'],
                              flightNumber: f['flightNumber'],
                              from: f['departureAirport'],
                              to: f['arrivalAirport'],
                              startDate: f['startDate'],
                              endDate: f['endDate'],
                              departureTime: f['departureTime'],
                              arrivalTime: f['arrivalTime'],
                            ),

                            const SizedBox(height: 30),

                            /// → WEATHER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                WeatherCard(
                                  title: "Local",
                                  location: "Calgary (YYC)",
                                  temp: localWeather != null
                                      ? "${localWeather!.temperature.toStringAsFixed(1)}°C"
                                      : "--°C",
                                  condition: localWeather?.condition ?? "Loading...",
                                ),
                                WeatherCard(
                                  title: "Destination",
                                  location: "Toronto (YYZ)",
                                  temp: destinationWeather != null
                                      ? "${destinationWeather!.temperature.toStringAsFixed(1)}°C"
                                      : "--°C",
                                  condition: destinationWeather?.condition ?? "Loading...",
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                          ],
                        );
                      }

                      /// ---- FLIGHT LIST ITEMS ----
                      final doc = docs[index];
                      final f = doc.data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.flight, color: Colors.white),
                          ),
                          title: Text("${f['flightNumber']} - ${f['airline']}"),
                          subtitle: Text(
                            "${f['departureAirport']} → ${f['arrivalAirport']}\n"
                            "Start: ${f['startDate']}   End: ${f['endDate']}\n"
                            "${f['departureTime']} - ${f['arrivalTime']}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("flights")
                                  .doc(doc.id)
                                  .delete();
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
