import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    setState(() => _isAddingBooking = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final data = {
        'userId': user.uid,
        'ownerEmail': user.email ?? 'no-email@unknown.com',
        'sharedWith': <String>[],
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Hotel booking added successfully!'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding booking: $e'), backgroundColor: Colors.red),
        );
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

  Future<void> _unshareBooking(String bookingId, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(bookingId)
          .update({'sharedWith': FieldValue.arrayRemove([email])});
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unshared from: $email')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to unshare: $e')));
      }
    }
  }

  Future<void> _shareBooking(String bookingId) async {
    final input = TextEditingController();
    final emails = await showDialog<List<String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Share booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter emails (comma-separated).'),
            const SizedBox(height: 8),
            TextField(
              controller: input,
              decoration: const InputDecoration(
                labelText: 'Emails',
                hintText: 'email1@example.com, email2@example.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final list = input.text
                  .split(',')
                  .map((e) => e.trim().toLowerCase())
                  .where((e) => e.isNotEmpty)
                  .toSet()
                  .toList();
              Navigator.pop(ctx, list);
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
    if (emails == null || emails.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(bookingId)
          .update({'sharedWith': FieldValue.arrayUnion(emails)});
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Shared with: ${emails.join(', ')}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to share: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Bookings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Add New Booking',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _hotelNameController,
                      decoration: const InputDecoration(
                        labelText: 'Hotel Name',
                        border: OutlineInputBorder(),
                        hintText: 'Grand Hotel',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        hintText: '123 Main St, City, Country',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: _checkInController,
                          decoration: const InputDecoration(
                            labelText: 'Check-in Date',
                            border: OutlineInputBorder(),
                            hintText: 'Select date',
                            suffixIcon: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          readOnly: true,
                          onTap: _selectCheckInDate,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _checkOutController,
                          decoration: const InputDecoration(
                            labelText: 'Check-out Date',
                            border: OutlineInputBorder(),
                            hintText: 'Select date',
                            suffixIcon: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          readOnly: true,
                          onTap: _selectCheckOutDate,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _isAddingBooking ? null : _addBooking,
                      child: _isAddingBooking
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
                          : const Text('Add Booking'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Text('Your Bookings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hotels')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  var bookings = snapshot.data?.docs ?? [];
                  bookings.sort((a, b) {
                    final aTime = (a.data() as Map<String, dynamic>)['addedAt'] as Timestamp?;
                    final bTime = (b.data() as Map<String, dynamic>)['addedAt'] as Timestamp?;
                    if (aTime == null && bTime == null) return 0;
                    if (aTime == null) return 1;
                    if (bTime == null) return -1;
                    return bTime.compareTo(aTime);
                  });
                  if (bookings.isEmpty) {
                    return const Center(
                      child: Text(
                        'No bookings added yet.\nAdd your first booking above!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, i) {
                      final doc = bookings[i];
                      final b = doc.data() as Map<String, dynamic>;
                      final shared = (b['sharedWith'] as List?)?.cast<String>() ?? const [];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Icon(Icons.hotel, color: Colors.white),
                          ),
                          title: Text('${b['hotelName']}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${b['address']}'),
                              Text('${b['checkIn']} → ${b['checkOut']}'),
                              if (shared.isNotEmpty)
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    const Text('Shared with: ',
                                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    ...shared.map((email) => Chip(
                                          label: Text(email, style: const TextStyle(fontSize: 11)),
                                          deleteIcon: const Icon(Icons.close, size: 16),
                                          onDeleted: () => _unshareBooking(doc.id, email),
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          visualDensity: VisualDensity.compact,
                                        )),
                                  ],
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.share, color: Colors.teal),
                                tooltip: 'Share',
                                onPressed: () => _shareBooking(doc.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteBooking(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            const Text('Shared Bookings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            SizedBox(
              height: 260,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hotels')
                    .where(
                      'sharedWith',
                      arrayContains: FirebaseAuth.instance.currentUser?.email?.toLowerCase(),
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  var bookings = snapshot.data?.docs ?? [];
                  bookings.sort((a, b) {
                    final aTime = (a.data() as Map<String, dynamic>)['addedAt'] as Timestamp?;
                    final bTime = (b.data() as Map<String, dynamic>)['addedAt'] as Timestamp?;
                    if (aTime == null && bTime == null) return 0;
                    if (aTime == null) return 1;
                    if (bTime == null) return -1;
                    return bTime.compareTo(aTime);
                  });
                  if (bookings.isEmpty) {
                    return const Center(
                      child: Text(
                        'No shared bookings yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, i) {
                      final doc = bookings[i];
                      final b = doc.data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Icon(Icons.hotel_outlined, color: Colors.white),
                          ),
                          title: Text('${b['hotelName']}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${b['address']}'),
                              Text('${b['checkIn']} → ${b['checkOut']}'),
                              Text(
                                'Shared by: ${b['ownerEmail'] ?? 'Unknown'}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                            ],
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
