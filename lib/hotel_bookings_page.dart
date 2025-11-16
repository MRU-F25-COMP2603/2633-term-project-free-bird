import 'package:flutter/material.dart';

class HotelBookingsPage extends StatefulWidget {
  const HotelBookingsPage({super.key});

  @override
  State<HotelBookingsPage> createState() => _HotelBookingsPageState();
}

class _HotelBookingsPageState extends State<HotelBookingsPage> {
  final TextEditingController _destinationController = TextEditingController();
  DateTimeRange? _dateRange;
  int _guests = 1;

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDateRange:
          _dateRange ??
          DateTimeRange(
            start: now.add(const Duration(days: 1)),
            end: now.add(const Duration(days: 4)),
          ),
      helpText: 'Select stay dates',
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _changeGuests(int delta) {
    setState(() {
      _guests = ((_guests + delta).clamp(1, 10) as int);
    });
  }

  void _onSearch() {
    final destination = _destinationController.text.trim();
    final snackBar = SnackBar(
      content: Text(
        destination.isEmpty
            ? 'Choose a destination to start searching.'
            : 'Searching hotels in $destination for $_guests guest(s)...',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String get _dateLabel {
    if (_dateRange == null) return 'Select dates';
    final start = _dateRange!.start;
    final end = _dateRange!.end;
    return '${start.month}/${start.day}/${start.year} - '
        '${end.month}/${end.day}/${end.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lavender = theme.colorScheme.inversePrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Bookings'),
        backgroundColor: lavender,
      ),
      body: Container(
        color: lavender.withOpacity(0.08),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan your stay',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Search and compare hotels for your next trip.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 24),

                // Destination field
                Text('Destination', style: theme.textTheme.labelLarge),
                const SizedBox(height: 6),
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    hintText: 'City, landmark, or hotel name',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Dates + Guests cards
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _InfoCard(
                        title: 'Dates',
                        subtitle: _dateLabel,
                        icon: Icons.calendar_month_outlined,
                        onTap: _pickDateRange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _GuestsCard(
                        guests: _guests,
                        onIncrement: () => _changeGuests(1),
                        onDecrement: () => _changeGuests(-1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Search button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.search),
                    label: const Text('Search Hotels'),
                    onPressed: _onSearch,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Suggested hotels list (static mock data)
                Text(
                  'Popular nearby stays',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const _HotelCard(
                  name: 'Lavender Sky Hotel',
                  location: 'Downtown • 0.8 km from center',
                  pricePerNight: 142,
                  rating: 4.6,
                  tags: ['Free Wi-Fi', 'Breakfast included'],
                ),
                const SizedBox(height: 10),
                const _HotelCard(
                  name: 'Free Bird Suites',
                  location: 'Near airport • 2.3 km away',
                  pricePerNight: 118,
                  rating: 4.3,
                  tags: ['Airport shuttle', '24/7 desk'],
                ),
                const SizedBox(height: 10),
                const _HotelCard(
                  name: 'City Lights Inn',
                  location: 'Riverside • 1.1 km from center',
                  pricePerNight: 165,
                  rating: 4.8,
                  tags: ['Great view', 'Flexible cancellation'],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, size: 24, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestsCard extends StatelessWidget {
  final int guests;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _GuestsCard({
    required this.guests,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 👈 shrink-wrap height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guests',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8), // 👈 use fixed spacing instead of Spacer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$guests',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: onDecrement,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: onIncrement,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final String name;
  final String location;
  final int pricePerNight;
  final double rating;
  final List<String> tags;

  const _HotelCard({
    required this.name,
    required this.location,
    required this.pricePerNight,
    required this.rating,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lavender = theme.colorScheme.inversePrimary.withOpacity(0.2);

    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Later you can navigate to a details screen here.
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Placeholder image box
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: lavender,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.hotel, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: -4,
                      children: tags
                          .map(
                            (t) => Chip(
                              label: Text(
                                t,
                                style: const TextStyle(fontSize: 11),
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        rating.toStringAsFixed(1),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$$pricePerNight',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/night',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
