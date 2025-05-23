import 'package:flutter/material.dart';
import 'package:pingpal/src/services/friend_service.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';

class PalsScreen extends StatefulWidget {
  const PalsScreen({Key? key}) : super(key: key);

  @override
  _PalsScreenState createState() => _PalsScreenState();
}

class _PalsScreenState extends State<PalsScreen> with NavBarPadding {
  final FriendService _friendService =
      FriendService(); // Create an instance of FriendService
  String _selectedFilter = 'All';
  String _selectedSort = 'Name';
  bool _isFriendRequestsExpanded = true; // Start expanded

  List<dynamic> _searchResults = []; // Holds the search results
  List<dynamic> _friendRequests = []; // Holds friend requests
  List<dynamic> _friends = []; // Holds the list of accepted friends
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    _fetchFriendRequests(); // Fetch friend requests on initialization
    _fetchFriends(); // Fetch accepted friends on initialization
  }

  Future<void> _fetchFriends() async {
    try {
      final friends = await _friendService.fetchFriends();
      setState(() {
        _friends = friends;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _fetchFriendRequests() async {
    try {
      final requests = await _friendService.fetchFriendRequests();
      setState(() {
        _friendRequests = requests;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _searchUsers(String query) async {
    try {
      final results = await _friendService.searchUsers(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _sendFriendRequest(String email) async {
    try {
      await _friendService.sendFriendRequest(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request sent to $email!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send friend request: $e')),
      );
    }
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
        actions: [_buildSortMenu(theme)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchFriendRequests();
          await _fetchFriends();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Search Bar
            SliverPersistentHeader(
              delegate: _SearchBarDelegate(
                child: _buildSearchBar(theme, isDarkMode),
              ),
              pinned: true,
            ),
            // Friend Requests Section
            SliverToBoxAdapter(
              child: _buildFriendRequestsSection(theme),
            ),
            // Friends List Section
            SliverToBoxAdapter(
              child: _buildFriendsListSection(theme),
            ),
            // Search Results Section
            SliverToBoxAdapter(
              child: _buildSearchResults(theme),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
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
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for friends...',
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
          onSubmitted: (query) {
            _searchUsers(query); // Trigger search when user submits query
          },
        ),
      ),
    );
  }

  Widget _buildFriendsListSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Pals',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _friends.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No friends yet. Search for friends above!',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                )
              : Column(
                  children: _friends.map((friend) {
                    return _buildFriendCard(friend, theme);
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildFriendCard(Map<String, dynamic> friend, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: const AssetImage('assets/images/profile_placeholder.png'),
        ),
        title: Text(friend['name'] ?? 'Unknown'),
        subtitle: Text(friend['email'] ?? ''),
        trailing: IconButton(
          icon: const Icon(Icons.message),
          onPressed: () {
            // Handle messaging friend
          },
        ),
        onTap: () {
          _showPalDetails(
            friend['name'] ?? 'Unknown',
            friend['status'] ?? 'No status',
            friend['location'] ?? 'No location',
            theme,
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    return _searchResults.isNotEmpty
        ? Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Results',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ..._searchResults.map((result) {
                  return _buildSearchResultCard(result, theme);
                }).toList(),
              ],
            ),
          )
        : Container();
  }

  Widget _buildSearchResultCard(Map<String, dynamic> result, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(
              'assets/images/profile_placeholder.png'), // Placeholder for user image
        ),
        title: Text(result['name']),
        subtitle: Text(result['email']),
        trailing: IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {
            _sendFriendRequest(
                result['email']); // Send friend request to this user
          },
        ),
      ),
    );
  }

  Widget _buildFriendRequestsSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              'Friend Requests',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: theme.colorScheme.secondary,
              child: Text(
                '${_friendRequests.length}',
                style: TextStyle(
                    color: theme.colorScheme.onSecondary, fontSize: 12),
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
        children: _friendRequests.map((request) {
          return _buildFriendRequestCard(request, theme);
        }).toList(),
      ),
    );
  }

  Widget _buildFriendRequestCard(
      Map<String, dynamic> request, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(
              'assets/images/profile_placeholder.png'), // Placeholder for sender's image
        ),
        title: Text(request['senderName']), // Display sender's name
        subtitle: const Text('Friend request'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {
                _acceptFriendRequest(request['id']); // Accept friend request
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                _declineFriendRequest(request['id']); // Decline friend request
              },
            ),
          ],
        ),
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

  Future<void> _acceptFriendRequest(String requestId) async {
    try {
      print("Sending request to accept friend request ID: $requestId");
      await _friendService.acceptFriendRequest(requestId);
      print("Successfully accepted friend request: $requestId");
      
      // Update the UI by fetching fresh data
      await _fetchFriendRequests();
      await _fetchFriends();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request accepted')),
      );
    } catch (e) {
      print("Error accepting friend request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting friend request: $e')),
      );
    }
  }

  Future<void> _declineFriendRequest(String requestId) async {
    try {
      await _friendService.declineFriendRequest(requestId);
      setState(() {
        _friendRequests.removeWhere((req) => req['id'] == requestId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request declined')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
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
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: theme.colorScheme.secondary),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(location, style: theme.textTheme.bodyMedium),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle message action
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary),
                  child: const Text('Message'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle remove pal action
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Remove Pal'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// SliverPersistentHeaderDelegate class for sticky header
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 80; // Adjust as needed
  @override
  double get minExtent => 80; // Adjust as needed
  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
