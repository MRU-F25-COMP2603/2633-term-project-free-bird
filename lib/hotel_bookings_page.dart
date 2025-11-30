import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'language_provider.dart';
import 'translations.dart';

/// ---------------------------------------------------------------------
///  HOTEL OVERVIEW CARD (Ticket-style)
/// ---------------------------------------------------------------------
class HotelOverviewCard extends StatelessWidget {
  final String name;
  final String address;
  final String checkIn;
  final String checkOut;

  const HotelOverviewCard({
    super.key,
    required this.name,
    required this.address,
    required this.checkIn,
    required this.checkOut,
  });

  static final _rand = Random();

  // Random status
  static const _statuses = ["CONFIRMED", "CHECK-IN SOON", "CHECKED IN", "CANCELLED"];

  Color _statusColor(String status) {
    switch (status) {
      case "CHECK-IN SOON":
        return Colors.orange;
      case "CHECKED IN":
        return Colors.blue;
      case "CANCELLED":
        return Colors.red;
      default:
        return Colors.green; // confirmed
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _statuses[_rand.nextInt(_statuses.length)];
    final room = 100 + _rand.nextInt(400);
    final stars = 3 + _rand.nextInt(3); // 3–5 stars

    // Convert dates for nights calculation
    final inDate = DateTime.tryParse(checkIn) ?? DateTime.now();
    final outDate = DateTime.tryParse(checkOut) ?? DateTime.now();
    final nights = outDate.difference(inDate).inDays;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
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
          /// TOP: Hotel name + stars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(
                  stars,
                  (_) => const Icon(Icons.star, color: Colors.amber, size: 20),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(address, style: const TextStyle(fontSize: 15, color: Colors.black87)),

          const SizedBox(height: 16),

          /// CHECK-IN / CHECK-OUT ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Check-in", style: TextStyle(color: Colors.black54)),
                    Text(checkIn, style: const TextStyle(fontSize: 16)),
                  ]),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Check-out", style: TextStyle(color: Colors.black54)),
                    Text(checkOut, style: const TextStyle(fontSize: 16)),
                  ]),
            ],
          ),

          const SizedBox(height: 12),

          Text("Nights: $nights",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

          const SizedBox(height: 16),

          /// STATUS + ROOM
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(status),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Text("Room: $room"),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------
///  AMENITIES BAR
/// ---------------------------------------------------------------------

class AmenitiesBar extends StatelessWidget {
  const AmenitiesBar({super.key});

  @override
  Widget build(BuildContext context) {
    const amenities = [
      {"icon": Icons.wifi, "label": "Wi-Fi"},
      {"icon": Icons.free_breakfast, "label": "Breakfast"},
      {"icon": Icons.pool, "label": "Pool"},
      {"icon": Icons.fitness_center, "label": "Gym"},
      {"icon": Icons.local_parking, "label": "Parking"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: amenities.map((a) {
        return Column(
          children: [
            Icon(a["icon"] as IconData, color: Colors.blueAccent, size: 28),
            const SizedBox(height: 4),
            Text(a["label"] as String, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}

/// =====================================================================
///  MAIN PAGE
/// =====================================================================

class HotelBookingsPage extends StatefulWidget {
  const HotelBookingsPage({super.key});

  @override
  State<HotelBookingsPage> createState() => _HotelBookingsPageState();
}

class _HotelBookingsPageState extends State<HotelBookingsPage> {
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  bool _isAddingBooking = false;

  @override
  void dispose() {
    _hotelNameController.dispose();
    _addressController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  Future<void> _selectCheckInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        _checkInController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: _checkInDate ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
        _checkOutController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _addBooking() async {
    final hotelName = _hotelNameController.text.trim();
    final address = _addressController.text.trim();
    final checkIn = _checkInController.text.trim();
    final checkOut = _checkOutController.text.trim();

    if (hotelName.isEmpty || address.isEmpty || checkIn.isEmpty || checkOut.isEmpty) {
      if (mounted) {
        final lang = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppTranslations.get('please_fill_all_fields', lang))));
      }
      return;
    }

    setState(() => _isAddingBooking = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final data = {
        'userId': user.uid,
        'ownerEmail': user.email ?? 'no-email@unknown.com',
        'hotelName': hotelName,
        'address': address,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'addedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('hotels').add(data);

      _hotelNameController.clear();
      _addressController.clear();
      _checkInController.clear();
      _checkOutController.clear();
      _checkInDate = null;
      _checkOutDate = null;

      if (mounted) {
        final lang = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppTranslations.get('hotel_booking_added', lang)),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error adding booking: $e')));
      }
    } finally {
      if (mounted) setState(() => _isAddingBooking = false);
    }
  }

  Future<void> _deleteBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance.collection('hotels').doc(bookingId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Booking removed successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error removing booking: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = LanguageProvider.currentOrDefault(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('hotel_bookings', language)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// ------------------ ADD NEW BOOKING FORM -------------------
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppTranslations.get('add_new_booking', language),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _hotelNameController,
                      decoration: InputDecoration(
                        labelText: AppTranslations.get('hotel_name', language),
                        border: const OutlineInputBorder(),
                        hintText: 'Grand Hotel',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: AppTranslations.get('address', language),
                        border: const OutlineInputBorder(),
                        hintText: '123 Main St, City, Country',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _checkInController,
                            decoration: InputDecoration(
                              labelText: AppTranslations.get('check_in_date', language),
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: _selectCheckInDate,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _checkOutController,
                            decoration: InputDecoration(
                              labelText: AppTranslations.get('check_out_date', language),
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: _selectCheckOutDate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _isAddingBooking ? null : _addBooking,
                      child: _isAddingBooking
                          ? const CircularProgressIndicator(strokeWidth: 2)
                          : Text(AppTranslations.get('add_booking', language)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            Text(AppTranslations.get('your_bookings', language),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            /// ------------------ BOOKINGS LIST -------------------
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hotels')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        AppTranslations.get('no_bookings', language),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length + 1, // +1 = overview + amenities
                    itemBuilder: (context, index) {
                      if (index == docs.length) {
                        final b = docs.first.data() as Map<String, dynamic>;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              AppTranslations.get('hotel_overview', language),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),

                            HotelOverviewCard(
                              name: b['hotelName'],
                              address: b['address'],
                              checkIn: b['checkIn'],
                              checkOut: b['checkOut'],
                            ),

                            /// AMENITIES ROW
                            const AmenitiesBar(),
                            const SizedBox(height: 30),
                          ],
                        );
                      }

                      final doc = docs[index];
                      final b = doc.data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Icon(Icons.hotel, color: Colors.white),
                          ),
                          title: Text("${b['hotelName']}"),
                          subtitle: Text("${b['address']}\n${b['checkIn']} → ${b['checkOut']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteBooking(doc.id),
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
