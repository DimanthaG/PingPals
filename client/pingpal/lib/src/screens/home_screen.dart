import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Ensure the path is correct
              height: 300, // Adjust the height as needed
            )
          ],
        ),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(0, 0, 0, 0) // Dark Mode Orange
            : const Color.fromARGB(0, 0, 0, 0), // Light Mode Yellow
        elevation: 0,
        centerTitle: true,
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
                          color: isDarkMode ? Colors.white70 : Colors.black54),
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),

              // Pinned Events Section
              const SizedBox(height: 20),
              Text(
                'Pinned Events',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
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
              _buildSectionHeader('Upcoming Events', theme, isDarkMode),
              Divider(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                thickness: 1,
                height: 20,
              ),
              const SizedBox(height: 10),
              _buildEventCard(
                title: 'Deal!',
                organizer: 'Geeneth Kulutunge',
                timeLeft: '12:22',
                participants: 'Nethma, Amantha, Dimantha, Hakkam',
                theme: theme,
                isDarkMode: isDarkMode,
                backgroundColor:
                    isDarkMode ? Color(0xFFEA580C) : Color(0xFFFFB74D),
                textColor: isDarkMode ? Colors.white : Colors.black,
              ),
              _buildEventCard(
                title: 'QuickWit',
                organizer: 'Roosanda',
                timeLeft: '1:30:12',
                participants: 'Nethma, Amantha, Dimantha',
                theme: theme,
                isDarkMode: isDarkMode,
                backgroundColor:
                    isDarkMode ? Color(0xFFD81B60) : Color(0xFFF48FB1),
                textColor: isDarkMode ? Colors.white : Colors.black,
              ),
              _buildEventCard(
                title: 'Minecraft',
                organizer: 'DimanthaG',
                timeLeft: '20:32',
                participants: 'Nethma',
                theme: theme,
                isDarkMode: isDarkMode,
                backgroundColor:
                    isDarkMode ? Color(0xFFEF6C00) : Color(0xFFFFCC80),
                textColor: isDarkMode ? Colors.white : Colors.black,
              ),

              // Invited Events Section
              const SizedBox(height: 30),
              _buildSectionHeader('Invited Events', theme, isDarkMode),
              Divider(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                thickness: 1,
                height: 20,
              ),
              const SizedBox(height: 10),
              _buildHorizontalScrollableEventCards(theme, isDarkMode,
                  isCreatedEvents: false),

              // Created Events Section
              const SizedBox(height: 30),
              _buildSectionHeader('Created Events', theme, isDarkMode),
              Divider(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                thickness: 1,
                height: 20,
              ),
              const SizedBox(height: 10),
              _buildHorizontalScrollableEventCards(theme, isDarkMode,
                  isCreatedEvents: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.calendar_today,
                  color: isDarkMode ? Colors.white70 : Colors.black),
              onPressed: () {
                // Navigate to a detailed section view
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
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
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF7B1FA2) : Color(0xFFCE93D8),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black54 : Colors.black12,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: isDarkMode
                        ? Color(0xFF3A58F3)
                        : Color(0xFF3A58F3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
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
                    Text(
                      'Geeneth Kulutunge',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDarkMode ? Colors.orange : Colors.blueAccent,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : theme.cardColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text: "Hey, I'll be a few minutes late",
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Leave a comment...',
                                hintStyle: theme.textTheme.labelSmall?.copyWith(
                                    color: isDarkMode
                                        ? Colors.white54
                                        : Colors.black54),
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
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
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
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle event card tap
      },
      child: SizedBox(
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    theme.textTheme.headlineSmall?.copyWith(color: textColor),
              ),
              const SizedBox(height: 5),
              Text(
                organizer,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                participants,
                style: TextStyle(color: textColor.withOpacity(0.7)),
              ),
              const SizedBox(height: 10),
              Text(
                'in $timeLeft',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollableEventCards(ThemeData theme, bool isDarkMode,
      {required bool isCreatedEvents}) {
    List<Color> eventColors = [
      isDarkMode ? Colors.blue[800]! : Colors.blue[100]!,
      isDarkMode ? Colors.green[800]! : Colors.green[100]!,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < 3; i++)
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: _buildEventCardSmall(
                title: 'Longlegs',
                date: '22/08/2024',
                time: '14:00',
                accepted: 'Geeneth',
                theme: theme,
                isDarkMode: isDarkMode,
                cardColor: isCreatedEvents ? eventColors[1] : eventColors[0],
                textColor: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
        ],
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
        width: 200, // Adjusted width for horizontal scrolling
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: textColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$date | $time',
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: Colors.orange),
              ),
              const SizedBox(height: 10),
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
}
