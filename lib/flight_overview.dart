import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';
import 'translations.dart';

class DataOverviewPage extends StatelessWidget {
  const DataOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final language = Provider.of<LanguageProvider>(context).currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('data_overview', language)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: userId == null
          ? Center(child: Text(AppTranslations.get('please_log_in', language)))
          : _buildOverviewContent(userId, language),
    );
  }

  Widget _buildOverviewContent(String userId, String language) {
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
                    AppTranslations.get('your_travel_dashboard', language),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppTranslations.get('overview_of_travel', language),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          //  Flights Summary 
          _buildSectionHeader(AppTranslations.get('flights', language)),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('flights')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildSummaryCard(
                  icon: Icons.flight,
                  title: AppTranslations.get('flights', language),
                  value: AppTranslations.get('loading', language),
                  subtitle: AppTranslations.get('your_flight_history', language),
                  color: Colors.blue,
                );
              }

              final flights = snapshot.data?.docs ?? [];
              final recentFlights = flights.take(3).toList();

              return Column(
                children: [
                  _buildSummaryCard(
                    icon: Icons.flight,
                    title: AppTranslations.get('total_flights', language),
                    value: flights.length.toString(),
                    subtitle: AppTranslations.get('flights_tracked', language),
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
          _buildSectionHeader(AppTranslations.get('documents_count', language)),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('files')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildSummaryCard(
                  icon: Icons.folder,
                  title: AppTranslations.get('documents_count', language),
                  value: AppTranslations.get('loading', language),
                  subtitle: AppTranslations.get('your_stored_files', language),
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
                title: AppTranslations.get('stored_documents_title', language),
                value: files.length.toString(),
                subtitle: '${(totalSize / 1024 / 1024).toStringAsFixed(2)} ${AppTranslations.get('mb_total', language)}',
                color: Colors.green,
              );
            },
          ),

          const SizedBox(height: 16),

          // Quick Stats 
          _buildSectionHeader(AppTranslations.get('quick_stats', language)),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.flight_takeoff,
                  value: AppTranslations.get('flights', language),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.folder_open,
                  value: AppTranslations.get('documents_count', language),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.translate,
                  value: AppTranslations.get('translate', language),
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Recent Activity (unchanged)
          _buildSectionHeader(AppTranslations.get('recent_activity', language)),
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
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        AppTranslations.get('no_recent_activity', language),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
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
