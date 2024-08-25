import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PingPals!',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: theme.colorScheme.onPrimary),
            onPressed: () {
              // Handle notification tap
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: theme.colorScheme.onPrimary),
            onPressed: () {
              // Handle profile tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search,
                          color: isDarkMode ? Colors.white54 : Colors.black54),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                  ),
                ),
              ),

              // Pinned Events Section
              const SizedBox(height: 20),
              Text(
                'Pinned Events',
                style: theme.textTheme.headlineSmall,
              ),
              Divider(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                thickness: 1,
                height: 20,
              ),
              const SizedBox(height: 10),
              _buildPinnedEventCard(theme, isDarkMode),

              // Upcoming Events Section
              const SizedBox(height: 30),
              _buildSectionHeader('Upcoming Events', Colors.blueAccent,
                  Icons.calendar_today, theme),
              const SizedBox(height: 10),
              _buildEventCard(
                title: 'Deal!',
                organizer: 'Geeneth Kulutunge',
                timeLeft: '12:22',
                participants: 'Nethma, Amantha, Dimantha, Hakkam',
                theme: theme,
                isDarkMode: isDarkMode,
              ),
              _buildEventCard(
                title: 'QuickWit',
                organizer: 'Roosanda',
                timeLeft: '1:30:12',
                participants: 'Nethma, Amantha, Dimantha',
                theme: theme,
                isDarkMode: isDarkMode,
              ),
              _buildEventCard(
                title: 'Minecraft',
                organizer: 'DimanthaG',
                timeLeft: '20:32',
                participants: 'Nethma',
                theme: theme,
                isDarkMode: isDarkMode,
              ),

              // Invited Events Section
              const SizedBox(height: 30),
              _buildSectionHeader(
                  'Invited Events', Colors.green, Icons.mail_outline, theme),
              const SizedBox(height: 10),
              _buildEventCardSmall(
                title: 'Longlegs',
                date: '22/08/2024',
                time: '14:00',
                accepted: 'Geeneth',
                theme: theme,
                isDarkMode: isDarkMode,
                cardColor: isDarkMode ? Colors.green[800]! : Colors.green[100]!,
                textColor: isDarkMode ? Colors.white : Colors.black87,
              ),
              _buildEventCardSmall(
                title: 'Longlegs',
                date: '22/08/2024',
                time: '14:00',
                accepted: 'Geeneth',
                theme: theme,
                isDarkMode: isDarkMode,
                cardColor: isDarkMode ? Colors.green[800]! : Colors.green[100]!,
                textColor: isDarkMode ? Colors.white : Colors.black87,
              ),

              // Created Events Section
              const SizedBox(height: 30),
              _buildSectionHeader('Created Events', Colors.orangeAccent,
                  Icons.add_circle_outline, theme),
              const SizedBox(height: 10),
              _buildEventCardSmall(
                title: 'Longlegs',
                date: '22/08/2024',
                time: '14:00',
                accepted: 'Geeneth',
                theme: theme,
                isDarkMode: isDarkMode,
                cardColor:
                    isDarkMode ? Colors.orange[800]! : Colors.orange[100]!,
                textColor: isDarkMode ? Colors.white : Colors.black87,
              ),
              _buildEventCardSmall(
                title: 'Longlegs',
                date: '22/08/2024',
                time: '14:00',
                accepted: 'Geeneth',
                theme: theme,
                isDarkMode: isDarkMode,
                cardColor:
                    isDarkMode ? Colors.orange[800]! : Colors.orange[100]!,
                textColor: isDarkMode ? Colors.white : Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, Color color, IconData icon, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(icon, color: color),
              onPressed: () {
                // Navigate to a detailed section view
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPinnedEventCard(ThemeData theme, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        // Navigate to event details
      },
      child: SizedBox(
        width: double.infinity, // Fill the entire width of the screen
        child: Container(
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 60, 62, 91), // Darker shade
                      Color.fromARGB(
                          255, 70, 73, 100), // Slightly lighter shade
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black26 : Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Banner
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(87, 101, 242, 1),
                      Color.fromRGBO(74, 144, 226, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.discord, size: 40, color: Colors.white),
                    Spacer(),
                    Text(
                      'Clubhouse',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Title and Countdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deal!',
                          style: theme.textTheme.headlineSmall?.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                        Text(
                          'in 12:22',
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: isDarkMode ? Colors.grey : Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Organizer Name
                    Text(
                      'Geeneth Kulutunge',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDarkMode ? Colors.orange : Colors.blueAccent,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),

                    // Participant List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildParticipantColumn(
                            ['Amantha', 'Dimantha', 'Hakkam', 'Nethma'], theme),
                        _buildParticipantColumn(
                            ['Thulana', 'Geeneth', 'Sheveen', 'Autism'], theme),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Comment Box
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text: "Hey, I'll be a few minutes late",
                              ),
                              style: theme.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Leave a comment...',
                                hintStyle: theme.textTheme.labelSmall,
                              ),
                            ),
                          ),
                          Icon(Icons.send,
                              color:
                                  isDarkMode ? Colors.white54 : Colors.black54),
                        ],
                      ),
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

  Widget _buildParticipantColumn(List<String> participants, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: participants
          .map(
            (participant) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                participant,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.secondary),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String organizer,
    required String timeLeft,
    required String participants,
    required ThemeData theme,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle event card tap
      },
      child: SizedBox(
        width: double.infinity, // Fill the entire width of the screen
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? const LinearGradient(
                    colors: [Color(0xFF3A3D5C), Color(0xFF5A5D7C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFFF5F5F5), Color(0xFFFFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black87),
              ),
              const SizedBox(height: 5),
              // Organizer
              Text(
                organizer,
                style: TextStyle(
                  color: isDarkMode ? Colors.orange : Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              // Participants
              Text(
                participants,
                style: TextStyle(
                    color: isDarkMode ? Colors.grey[300] : Colors.black54),
              ),
              const SizedBox(height: 10),
              // Time Left
              LinearProgressIndicator(
                value: calculateTimeLeftPercentage(timeLeft),
                backgroundColor:
                    isDarkMode ? Colors.grey[800] : Colors.grey[300],
                color: isDarkMode ? Colors.redAccent : Colors.orangeAccent,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Join
                    },
                    child: Text('Join'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Details
                    },
                    child: Text('Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCardSmall({
    required String title,
    required String date,
    required String time,
    required String accepted,
    required ThemeData theme,
    required bool isDarkMode,
    required Color cardColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle small event card tap
      },
      child: SizedBox(
        width: double.infinity, // Fill the entire width of the screen
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: textColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              // Date and Time
              Text(
                '$date | $time',
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: Colors.orange),
              ),
              const SizedBox(height: 10),
              // Accepted
              Text(
                'Accepted: $accepted',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTimeLeftPercentage(String timeLeft) {
    // Dummy implementation to calculate the percentage of time left
    // Replace with actual calculation logic based on your event time
    return 0.5;
  }
}
