import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataOverviewPage extends StatelessWidget {
  const DataOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Overview'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: userId == null
          ? const Center(child: Text('Please log in to view your data'))
          : _buildOverviewContent(userId),
    );
  }

  Widget _buildOverviewContent(String userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Welcome Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Travel Dashboard',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Overview of all your travel data',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          //  Flights Summary 
          _buildSectionHeader('Flights'),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('flights')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildSummaryCard(
                  icon: Icons.flight,
                  title: 'Flights',
                  value: 'Loading...',
                  subtitle: 'Your flight history',
                  color: Colors.blue,
                );
              }

              final flights = snapshot.data?.docs ?? [];
              final recentFlights = flights.take(3).toList();

              return Column(
                children: [
                  _buildSummaryCard(
                    icon: Icons.flight,
                    title: 'Total Flights',
                    value: flights.length.toString(),
                    subtitle: 'Flights tracked',
                    color: Colors.blue,
                  ),

                  if (recentFlights.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildRecentFlights(recentFlights),
                  ],
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Documents Summary 
          _buildSectionHeader('Documents'),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('files')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildSummaryCard(
                  icon: Icons.folder,
                  title: 'Documents',
                  value: 'Loading...',
                  subtitle: 'Your stored files',
                  color: Colors.green,
                );
              }

              final files = snapshot.data?.docs ?? [];
              final totalSize = files.fold<int>(0, (sum, doc) {
                final data = doc.data() as Map<String, dynamic>;
                return sum + (data['size'] as int? ?? 0);
              });

              return _buildSummaryCard(
                icon: Icons.folder,
                title: 'Stored Documents',
                value: files.length.toString(),
                subtitle: '${(totalSize / 1024 / 1024).toStringAsFixed(2)} MB total',
                color: Colors.green,
              );
            },
          ),

          const SizedBox(height: 16),

          // Quick Stats 
          _buildSectionHeader('Quick Stats'),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.flight_takeoff,
                  value: 'Flights',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.folder_open,
                  value: 'Documents',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.translate,
                  value: 'Translate',
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Recent Activity (unchanged)
          _buildSectionHeader('Recent Activity'),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('flights')
                .where('userId', isEqualTo: userId)
                .orderBy('addedAt', descending: true)
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              final recentFlights = snapshot.data?.docs ?? [];

              if (recentFlights.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No recent activity\nAdd your first flight to get started!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              }

              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: recentFlights.map((doc) {
                      final flight = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        leading: const Icon(Icons.flight, color: Colors.blue),
                        title: Text(
                          '${flight['flightNumber']} - ${flight['airline']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${flight['departureAirport']} → ${flight['arrivalAirport']}',
                        ),
                        trailing: Text(
                          flight['date'] ?? '',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Header widget
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Summary Card
  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Stat Card
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Recent Flights Overview
  Widget _buildRecentFlights(List<QueryDocumentSnapshot> flights) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Flights',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),

            // List
            ...flights.map((doc) {
              final flight = doc.data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.flight, color: Colors.blue),
                title: Text(
                  '${flight['flightNumber']} - ${flight['airline']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${flight['departureAirport']} → ${flight['arrivalAirport']}',
                ),
                trailing: Text(
                  flight['date'] ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
