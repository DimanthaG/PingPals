import 'package:flutter/material.dart';
import 'package:pingpal/src/services/friend_service.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';
import 'package:pingpal/src/widgets/animated_background.dart';
import 'package:pingpal/src/widgets/custom_app_bar.dart';

class PalsScreen extends StatefulWidget {
  const PalsScreen({Key? key}) : super(key: key);

  @override
  _PalsScreenState createState() => _PalsScreenState();
}

class _PalsScreenState extends State<PalsScreen> with NavBarPadding {
  final FriendService _friendService =
      FriendService(); // Create an instance of FriendService
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
      if (mounted) {
        setState(() {
          _friends = friends;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _fetchFriendRequests() async {
    try {
      final requests = await _friendService.fetchFriendRequests();
      if (mounted) {
        setState(() {
          _friendRequests = requests;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _searchUsers(String query) async {
    try {
      final results = await _friendService.searchUsers(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _sendFriendRequest(String email) async {
    try {
      await _friendService.sendFriendRequest(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend request sent to $email!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send friend request: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            await _fetchFriendRequests();
            await _fetchFriends();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16.0,
                      left: 16.0,
                      right: 16.0),
                  child: _buildHeaderWithSort(theme),
                ),
              ),
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
      ),
    );
  }

  Widget _buildHeaderWithSort(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people,
                  size: 24,
                  color: Color(0xFFFF8C00),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Pals',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFFFF8C00),
                ),
              ),
            ],
          ),
          _buildSortMenu(theme),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, bool isDarkMode) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900]?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for friends...',
            hintStyle:
                theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
            prefixIcon: const Icon(Icons.search, color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
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
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          _friends.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No friends yet. Search for friends above!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              const AssetImage('assets/images/profile_placeholder.png'),
        ),
        title: Text(
          friend['name'] ?? 'Unknown',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        subtitle: Text(
          friend['email'] ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: const Icon(Icons.message, color: Color(0xFFFF8C00)),
            onPressed: () {
              // Handle messaging friend
            },
          ),
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
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(
              'assets/images/profile_placeholder.png'), // Placeholder for user image
        ),
        title: Text(
          result['name'],
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          result['email'],
          style: TextStyle(color: Colors.white54),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: const Icon(Icons.person_add, color: Color(0xFFFF8C00)),
            onPressed: () {
              _sendFriendRequest(
                  result['email']); // Send friend request to this user
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFriendRequestsSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900]?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Row(
              children: [
                Text(
                  'Friend Requests',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: const Color(0xFFFF8C00),
                  child: Text(
                    '${_friendRequests.length}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            initiallyExpanded: _isFriendRequestsExpanded,
            iconColor: const Color(0xFFFF8C00),
            collapsedIconColor: Colors.white54,
            onExpansionChanged: (expanded) {
              if (mounted) {
                setState(() {
                  _isFriendRequestsExpanded = expanded;
                });
              }
            },
            children: _friendRequests.map((request) {
              return _buildFriendRequestCard(request, theme);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendRequestCard(
      Map<String, dynamic> request, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(
              'assets/images/profile_placeholder.png'), // Placeholder for sender's image
        ),
        title: Text(
          request['senderName'],
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: const Text('Friend request',
            style: TextStyle(color: Colors.white54)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  _acceptFriendRequest(request['id']); // Accept friend request
                },
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  _declineFriendRequest(
                      request['id']); // Decline friend request
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortMenu(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFF8C00).withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.sort, color: Color(0xFFFF8C00)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onSelected: (value) {
          // Sort friends based on selected value
          if (mounted) {
            setState(() {
              // No need to store the selection in a field
              _sortFriends(value);
            });
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'Name',
            child: Row(
              children: [
                Icon(Icons.sort_by_alpha, size: 18, color: Color(0xFFFF8C00)),
                SizedBox(width: 8),
                Text('Sort by Name'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'Status',
            child: Row(
              children: [
                Icon(Icons.settings, size: 18, color: Color(0xFFFF8C00)),
                SizedBox(width: 8),
                Text('Sort by Status'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'Recent Activity',
            child: Row(
              children: [
                Icon(Icons.history, size: 18, color: Color(0xFFFF8C00)),
                SizedBox(width: 8),
                Text('Sort by Recent Activity'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sortFriends(String sortOption) {
    // Implementation of sorting logic
    switch (sortOption) {
      case 'Name':
        _friends.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Status':
        // Sort by status if available
        break;
      case 'Recent Activity':
        // Sort by recent activity if available
        break;
    }
  }

  Future<void> _acceptFriendRequest(String requestId) async {
    try {
      print("Sending request to accept friend request ID: $requestId");
      await _friendService.acceptFriendRequest(requestId);
      print("Successfully accepted friend request: $requestId");

      // Update the UI by fetching fresh data
      if (mounted) {
        await _fetchFriendRequests();
        await _fetchFriends();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend request accepted')),
        );
      }
    } catch (e) {
      print("Error accepting friend request: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accepting friend request: $e')),
        );
      }
    }
  }

  Future<void> _declineFriendRequest(String requestId) async {
    try {
      await _friendService.declineFriendRequest(requestId);
      if (mounted) {
        setState(() {
          _friendRequests.removeWhere((req) => req['id'] == requestId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend request declined')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _showPalDetails(
      String name, String status, String location, ThemeData theme) {
    if (mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.0,
              ),
            ),
            child: SafeArea(
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        status,
                        style: TextStyle(
                          color: const Color(0xFFFF8C00),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8C00),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Handle message action
                        },
                        child: const Text(
                          'Message',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Handle remove pal action
                        },
                        child: const Text(
                          'Remove Pal',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
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
