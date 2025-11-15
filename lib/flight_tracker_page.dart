import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlightInputPage extends StatefulWidget {
  const FlightInputPage({super.key});

  @override
  State<FlightInputPage> createState() => _FlightInputPageState();
}

class _FlightInputPageState extends State<FlightInputPage> {
  // Controllers for manual entry fields
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _airlineController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _departureAirportController = TextEditingController();
  final TextEditingController _arrivalAirportController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  
  DateTime? _selectedDate;
  bool _isAddingFlight = false;

  @override
  void initState() {   
    super.initState();
  }

  // Opens a date picker dialog for user to select a date
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _addFlight() async {
    final flightNumber = _flightNumberController.text.trim().toUpperCase();
    final airline = _airlineController.text.trim();
    final flightDate = _dateController.text.trim();
    final departureAirport = _departureAirportController.text.trim();
    final arrivalAirport = _arrivalAirportController.text.trim();
    final departureTime = _departureTimeController.text.trim();
    final arrivalTime = _arrivalTimeController.text.trim();
    
    if (flightNumber.isEmpty || airline.isEmpty || flightDate.isEmpty || 
        departureAirport.isEmpty || arrivalAirport.isEmpty ||
        departureTime.isEmpty || arrivalTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isAddingFlight = true;
    });

    try {
      // Get current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create flight data from manual entry
      final flightData = {
        'userId': userId,
        'flightNumber': flightNumber,
        'airline': airline,
        'date': flightDate,
        'departureAirport': departureAirport,
        'arrivalAirport': arrivalAirport,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'addedAt': FieldValue.serverTimestamp(),
      };
      
      // Store in Firebase
      await FirebaseFirestore.instance.collection('flights').add(flightData);

      // Clear all input fields
      _flightNumberController.clear();
      _airlineController.clear();
      _dateController.clear();
      _departureAirportController.clear();
      _arrivalAirportController.clear();
      _departureTimeController.clear();
      _arrivalTimeController.clear();
      _selectedDate = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flight added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding flight: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isAddingFlight = false;
      });
    }
  }

  Future<void> _deleteFlight(String flightId) async {
    try {
      await FirebaseFirestore.instance.collection('flights').doc(flightId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flight removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing flight: $e')),
      );
    }
  }

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Compact input form section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Add New Flight',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    
                    // Row 1: Flight Number and Airline
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _flightNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Flight Number',
                              border: OutlineInputBorder(),
                              hintText: 'AA123',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            textCapitalization: TextCapitalization.characters,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _airlineController,
                            decoration: const InputDecoration(
                              labelText: 'Airline',
                              border: OutlineInputBorder(),
                              hintText: 'Air Canada',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Row 2: Date
                    TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Flight Date',
                        border: OutlineInputBorder(),
                        hintText: 'Select date',
                        suffixIcon: Icon(Icons.calendar_today),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 8),
                    
                    // Row 3: From and To
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _departureAirportController,
                            decoration: const InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                              hintText: 'YYC',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _arrivalAirportController,
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                              hintText: 'YYZ',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Row 4: Departure and Arrival Times
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _departureTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Departure Time',
                              border: OutlineInputBorder(),
                              hintText: '08:30',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _arrivalTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Arrival Time',
                              border: OutlineInputBorder(),
                              hintText: '11:45',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    ElevatedButton(
                      onPressed: _isAddingFlight ? null : _addFlight,
                      child: _isAddingFlight
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 8),
                                Text('Adding...'),
                              ],
                            )
                          : const Text('Add Flight'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            const Text(
              'Your Flights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Scrollable flights list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('flights')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  var flights = snapshot.data?.docs ?? [];
                  
                  // Sort flights by addedAt timestamp (most recent first)
                  flights.sort((a, b) {
                    final aTime = (a.data() as Map<String, dynamic>)['addedAt'] as Timestamp?;
                    final bTime = (b.data() as Map<String, dynamic>)['addedAt'] as Timestamp?;
                    if (aTime == null && bTime == null) return 0;
                    if (aTime == null) return 1;
                    if (bTime == null) return -1;
                    return bTime.compareTo(aTime);
                  });
                  
                  if (flights.isEmpty) {
                    return const Center(
                      child: Text(
                        'No flights added yet.\nAdd your first flight above!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final flightDoc = flights[index];
                      final flight = flightDoc.data() as Map<String, dynamic>;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.flight, color: Colors.white),
                          ),
                          title: Text(
                            '${flight['flightNumber']} - ${flight['airline']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${flight['departureAirport']} → ${flight['arrivalAirport']}'),
                              Text('${flight['date']} | ${flight['departureTime']} - ${flight['arrivalTime']}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteFlight(flightDoc.id),
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
