import 'package:flutter/material.dart';

class PalsScreen extends StatefulWidget {
  const PalsScreen({super.key});

  @override
  _PalsScreenState createState() => _PalsScreenState();
}

class _PalsScreenState extends State<PalsScreen> {
  String _selectedFilter = 'All';
  String _selectedSort = 'Name';
  bool _isFriendRequestsExpanded =
      false; // For collapsing the friend requests section

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pals',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor:
            isDarkMode ? const Color(0xFFFF8C00) : const Color(0xFFFFC800),
        elevation: 0,
        centerTitle: true,
        actions: [
          _buildSortMenu(theme),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Material(
                elevation: 5,
                shadowColor: isDarkMode ? Colors.black54 : Colors.black12,
                borderRadius: BorderRadius.circular(30.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Pals...',
                    prefixIcon: Icon(Icons.search,
                        color: isDarkMode ? Colors.white54 : Colors.black54),
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Filter Options
            _buildFilterOptions(theme),

            const SizedBox(height: 20),

            // Friend Requests Section (Collapsible)
            _buildCollapsibleFriendRequestsSection(theme),

            const SizedBox(height: 20),

            // Pals List Section
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildPalCard(
                  theme,
                  isDarkMode,
                  'Pal Name $index',
                  'Last seen: 2 hours ago',
                  location: 'Location $index',
                  accepted: index % 2 == 0,
                  online: index % 3 == 0,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _navigateToFindFriendsPage(context);
        },
        label: const Text('Find New Friends'),
        icon: const Icon(Icons.person_add),
        backgroundColor: theme.colorScheme.secondary,
      ),
    );
  }

  Widget _buildFilterOptions(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFilterChip('All', theme),
        _buildFilterChip('Online', theme),
        _buildFilterChip('Offline', theme),
      ],
    );
  }

  Widget _buildFilterChip(String label, ThemeData theme) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedFilter == label,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: theme.cardColor,
      selectedColor: theme.colorScheme.secondary.withOpacity(0.3),
      labelStyle: TextStyle(
        color: _selectedFilter == label
            ? theme.colorScheme.onSecondary
            : theme.textTheme.bodyMedium?.color,
      ),
    );
  }

  Widget _buildSortMenu(ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.sort, color: theme.colorScheme.onPrimary),
      onSelected: (value) {
        setState(() {
          _selectedSort = value;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'Name',
          child: Text('Sort by Name'),
        ),
        PopupMenuItem(
          value: 'Status',
          child: Text('Sort by Status'),
        ),
        PopupMenuItem(
          value: 'Recent Activity',
          child: Text('Sort by Recent Activity'),
        ),
      ],
    );
  }

  Widget _buildCollapsibleFriendRequestsSection(ThemeData theme) {
    final friendRequests = [
      'Friend Request 1',
      'Friend Request 2',
      'Friend Request 3'
    ];

    return ExpansionTile(
      title: Text(
        'Friend Requests (${friendRequests.length})',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      initiallyExpanded: _isFriendRequestsExpanded,
      onExpansionChanged: (expanded) {
        setState(() {
          _isFriendRequestsExpanded = expanded;
        });
      },
      children: friendRequests.map((request) {
        return _buildFriendRequestCard(request, theme);
      }).toList(),
    );
  }

  Widget _buildFriendRequestCard(String name, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.check_circle, color: Colors.green),
                onPressed: () {
                  // Handle accept friend request
                },
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: () {
                  // Handle decline friend request
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPalCard(
      ThemeData theme, bool isDarkMode, String name, String status,
      {required String location,
      required bool accepted,
      required bool online}) {
    return GestureDetector(
      onTap: () {
        _showPalDetails(name, status, location, theme);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accepted
              ? theme.colorScheme.secondary.withOpacity(0.2)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  online ? Colors.greenAccent : theme.colorScheme.secondary,
              child: Text(
                name[0], // Initials of the pal's name
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              accepted ? Icons.check_circle : Icons.add_circle_outline,
              color: accepted ? theme.colorScheme.secondary : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showPalDetails(
      String name, String status, String location, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                status,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                location,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToFindFriendsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FindFriendsScreen()),
    );
  }
}

class FindFriendsScreen extends StatelessWidget {
  const FindFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find New Friends',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10, // Replace with the actual number of new friends
          itemBuilder: (context, index) {
            return _buildNewFriendCard(
              theme,
              'New Friend $index',
              'Recently active',
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewFriendCard(ThemeData theme, String name, String status) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.secondary,
            child: Text(
              name[0], // Initials of the friend's name
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline,
                color: theme.colorScheme.primary),
            onPressed: () {
              // Handle send friend request
            },
          ),
        ],
      ),
    );
  }
}
