import 'package:flutter/material.dart';

class PalsScreen extends StatefulWidget {
  const PalsScreen({Key? key}) : super(key: key);

  @override
  _PalsScreenState createState() => _PalsScreenState();
}

class _PalsScreenState extends State<PalsScreen> {
  String _selectedFilter = 'All';
  String _selectedSort = 'Name';
  bool _isFriendRequestsExpanded = true; // Start expanded

  int _currentIndex = 1; // For BottomNavigationBar, assuming Pals is at index 1

  final ScrollController _scrollController = ScrollController();

  Future<void> _refreshPalsList() async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
    // Update pals list
    setState(() {
      // Refresh data
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pals',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor:
            isDarkMode ? const Color(0xFFFF8C00) : const Color(0xFFFF8C00),
        elevation: 0,
        centerTitle: true,
        actions: [
          _buildSortMenu(theme),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPalsList,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Sticky Search Bar
            SliverPersistentHeader(
              delegate: _SearchBarDelegate(
                child: _buildSearchBar(theme, isDarkMode),
              ),
              pinned: true,
            ),
            // Filter Options
            SliverToBoxAdapter(
              child: _buildFilterOptions(theme),
            ),
            // Friend Requests Section
            SliverToBoxAdapter(
              child: _buildFriendRequestsSection(theme),
            ),
            // Pals List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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
                childCount: 10,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
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

  Widget _buildSearchBar(ThemeData theme, bool isDarkMode) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(16.0),
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
    );
  }

  Widget _buildFilterOptions(ThemeData theme) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', theme, Icons.all_inclusive),
          const SizedBox(width: 8),
          _buildFilterChip('Online', theme, Icons.circle, color: Colors.green),
          const SizedBox(width: 8),
          _buildFilterChip('Offline', theme, Icons.circle, color: Colors.grey),
          // Add more filters if needed
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ThemeData theme, IconData icon,
      {Color? color}) {
    return ChoiceChip(
      label: Row(
        children: [
          Icon(icon, size: 18, color: color ?? theme.iconTheme.color),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
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
            : theme.textTheme.bodyLarge?.color,
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
        const PopupMenuItem(
          value: 'Name',
          child: Text('Sort by Name'),
        ),
        const PopupMenuItem(
          value: 'Status',
          child: Text('Sort by Status'),
        ),
        const PopupMenuItem(
          value: 'Recent Activity',
          child: Text('Sort by Recent Activity'),
        ),
      ],
    );
  }

  Widget _buildFriendRequestsSection(ThemeData theme) {
    final friendRequests = [
      'Friend Request 1',
      'Friend Request 2',
      'Friend Request 3'
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              'Friend Requests',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: theme.colorScheme.secondary,
              child: Text(
                '${friendRequests.length}',
                style: TextStyle(
                  color: theme.colorScheme.onSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
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
      ),
    );
  }

  Widget _buildFriendRequestCard(String name, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage:
                AssetImage('assets/images/profile_placeholder.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle accept friend request
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: const Text('Accept'),
          ),
          TextButton(
            onPressed: () {
              // Handle decline friend request
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  Widget _buildPalCard(
    ThemeData theme,
    bool isDarkMode,
    String name,
    String status, {
    required String location,
    required bool accepted,
    required bool online,
  }) {
    return GestureDetector(
      onTap: () {
        _showPalDetails(name, status, location, theme);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.black12,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      AssetImage('assets/images/profile_placeholder.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: online ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.message, color: theme.colorScheme.primary),
              onPressed: () {
                // Handle message action
              },
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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              // Use Wrap to ensure minimum necessary height
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage(
                        'assets/images/profile_placeholder.png'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    name,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    status,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    location,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle message action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: const Text('Message'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle remove pal action
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Remove Pal'),
                ),
              ],
            ),
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

// Custom SliverPersistentHeaderDelegate to make the search bar sticky
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 80; // Adjust height as needed

  @override
  double get minExtent => 80; // Adjust height as needed

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class FindFriendsScreen extends StatelessWidget {
  const FindFriendsScreen({Key? key}) : super(key: key);

  Future<void> _refreshFriendsList() async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
    // Update friends list
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find New Friends',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFriendsList,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage:
                AssetImage('assets/images/profile_placeholder.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle send friend request
            },
            child: const Text('Add Friend'),
          ),
        ],
      ),
    );
  }
}
