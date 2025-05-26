import 'package:flutter/material.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';
import 'package:pingpal/src/widgets/animated_background.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EventsPage(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor:
            const Color(0xFF1C1C1E), // Dark background color
      ),
    );
  }
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with NavBarPadding {
  // List of events with dark mode colors
  final List<Map<String, dynamic>> _events = [
    {
      'title': 'Deal!',
      'subtitle': 'Geeneth Kulatunge',
      'time': 'in 12:22',
      'color': const Color(0xFFFFA400)
    }, // Created (Orange)
    {
      'title': 'QuickWit',
      'subtitle': 'Roosanda',
      'time': 'in 1:30:12',
      'color': const Color(0xFFF37A90)
    }, // Invited (Pink)
    {
      'title': 'Minecraft',
      'subtitle': 'DimanthaG',
      'time': 'in 20:32',
      'color': const Color(0xFFFFA400)
    }, // Created (Orange)
    {
      'title': 'Deal!',
      'subtitle': 'Geeneth Kulatunge',
      'time': 'in 12:22',
      'color': const Color(0xFFFFA400)
    }, // Created (Orange)
    {
      'title': 'QuickWit',
      'subtitle': 'Roosanda',
      'time': 'in 1:30:12',
      'color': const Color(0xFFF37A90)
    }, // Invited (Pink)
    {
      'title': 'Accepted Event',
      'subtitle': 'PersonA',
      'time': 'in 0:45:10',
      'color': const Color(0xFF6ECF68)
    }, // Accepted (Green)
    {
      'title': 'Declined Event',
      'subtitle': 'PersonB',
      'time': 'in 3:15:45',
      'color': const Color(0xFFD95555)
    }, // Declined (Red)
  ];

  // Variable to store the currently selected filter color
  Color? _selectedFilterColor;

  @override
  Widget build(BuildContext context) {
    // Filtered events based on selected filter color
    List<Map<String, dynamic>> _filteredEvents = _selectedFilterColor == null
        ? _events
        : _events
            .where((event) => event['color'] == _selectedFilterColor)
            .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        child: Column(
          children: [
            // Top spacing for status bar
            SizedBox(height: MediaQuery.of(context).padding.top),

            // Header section with title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C00).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.notifications,
                      size: 28,
                      color: Color(0xFFFF8C00),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section header with filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSectionHeader('Upcoming Events', context),
            ),

            // Search bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withOpacity(0.6) ??
                      Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    filled: true,
                    fillColor: Colors.transparent,
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    hintText: 'Search events...',
                    hintStyle:
                        const TextStyle(color: Colors.white54, fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Filter chips
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterButton(
                      'Created', const Color(0xFFFFA400)), // Orange
                  _buildFilterButton(
                      'Invited', const Color(0xFFF37A90)), // Pink
                  _buildFilterButton(
                      'Accepted', const Color(0xFF6ECF68)), // Green
                  _buildFilterButton(
                      'Declined', const Color(0xFFD95555)), // Red
                ],
              ),
            ),

            // Event cards list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 16,
                  right: 16,
                  bottom: NavBarPadding.getNavBarHeight(context) + 16.0,
                ),
                itemCount: _filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = _filteredEvents[index];
                  return _buildEventCard(
                    event['title'],
                    event['subtitle'],
                    event['time'],
                    event['color'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFFF8C00).withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_available,
              size: 22,
              color: Color(0xFFFF8C00),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFFF8C00).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFFF8C00),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle the selected filter color
          if (_selectedFilterColor == color) {
            _selectedFilterColor = null; // Clear the filter
          } else {
            _selectedFilterColor = color; // Apply the selected filter
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(_selectedFilterColor == color ? 0.8 : 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedFilterColor == color
                ? Colors.white
                : color.withOpacity(0.5),
            width: _selectedFilterColor == color ? 2 : 1,
          ),
          boxShadow: _selectedFilterColor == color
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: _selectedFilterColor == color
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(
      String title, String subtitle, String time, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color:
            Colors.grey[900]?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event color indicator
                Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),

                // Event details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: color.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                color: color,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Participants
            Row(
              children: [
                const Icon(
                  Icons.people,
                  size: 16,
                  color: Colors.white54,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Participants:',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildAvatarChip('Nethma'),
                        _buildAvatarChip('Amantha'),
                        _buildAvatarChip('Dimantha'),
                        _buildAvatarChip('Hakkam'),
                        _buildAvatarOverflow(2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarChip(String name) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOverflow(int extraCount) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '+$extraCount more',
        style: const TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
