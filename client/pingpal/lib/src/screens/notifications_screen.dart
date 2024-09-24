import 'package:flutter/material.dart';

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
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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
      backgroundColor: const Color(0xFF1C1C1E), // Dark background color
      body: Column(
        children: [
          // Top blue section with rounded bottom corners and "Events" title
          Container(
            decoration: const BoxDecoration(
              color: const Color(0xFFFF8C00),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding above "Events"
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0, top: 8.0),
                  child: Center(
                    child: Text(
                      'Events',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    hintText: 'Search...',
                    hintStyle:
                        const TextStyle(color: Colors.black54, fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Filter chips
                Row(
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
              ],
            ),
          ),
          // Event cards list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              children: _filteredEvents.map((event) {
                return _buildEventCard(
                  event['title'],
                  event['subtitle'],
                  event['time'],
                  event['color'],
                );
              }).toList(),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: _selectedFilterColor == color
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(
      String title, String subtitle, String time, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // Align vertically
        children: [
          Expanded(
            // Expands text without overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                // Avatars for participants
                Wrap(
                  spacing: 8.0, // Space between avatars
                  runSpacing: 8.0,
                  children: [
                    _buildAvatar('Nethma'),
                    _buildAvatar('Amantha'),
                    _buildAvatar('Dimantha'),
                    _buildAvatar('Hakkam'),
                    _buildAvatarOverflow(2), // Indicates more participants
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8), // Spacing between text and time
          // Right-side time display
          Flexible(
            child: Text(
              time,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: Text(
        name[0], // Display first initialr
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAvatarOverflow(int extraCount) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white.withOpacity(0.6),
      child: Text(
        '+$extraCount', // Indicate extra participants
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
