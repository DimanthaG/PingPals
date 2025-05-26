import 'package:flutter/material.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';
import 'package:pingpal/src/widgets/animated_background.dart';
import 'package:pingpal/src/widgets/custom_app_bar.dart';
import 'package:pingpal/src/widgets/gradient_background.dart';

class HomeScreen extends StatelessWidget with NavBarPadding {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        child: SingleChildScrollView(
          padding: NavBarPadding.getScreenPadding(context),
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16.0,
                left: 16.0,
                right: 16.0,
                bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PingPals Header
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8C00).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.bolt,
                          size: 24,
                          color: Color(0xFFFF8C00),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'PingPals',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFFFF8C00),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.white54),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),

                // Pinned Events Section
                Text(
                  'Pinned Events',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFFF8C00),
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
                  textColor: Colors.white,
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
                  textColor: Colors.white,
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
                  textColor: Colors.white,
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
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            child: Icon(
              title.contains('Upcoming')
                  ? Icons.event_available
                  : title.contains('Invited')
                      ? Icons.mail
                      : Icons.create,
              size: 22,
              color: const Color(0xFFFF8C00),
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
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: const Color(0xFFFF8C00),
            ),
          ),
        ],
      ),
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
            color: Colors.grey[900]?.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.discord,
                          size: 30, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      'Clubhouse',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFFFF8C00),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.pin_drop,
                          size: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
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
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.red.withOpacity(0.5)),
                          ),
                          child: Text(
                            'in 12:22',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.person,
                            size: 18, color: Color(0xFFFF8C00)),
                        const SizedBox(width: 8),
                        Text(
                          'Geeneth Kulutunge',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFFFF8C00),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people,
                                  size: 18,
                                  color: Colors.white.withOpacity(0.7)),
                              const SizedBox(width: 8),
                              Text(
                                'Participants',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildParticipantColumn(
                                  ['Amantha', 'Dimantha', 'Hakkam', 'Nethma'],
                                  theme),
                              _buildParticipantColumn(
                                  ['Thulana', 'Geeneth', 'Sheveen', '+2 more'],
                                  theme),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text: "Hey, I'll be a few minutes late",
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Leave a comment...',
                                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(Icons.send,
                                size: 20, color: Color(0xFFFF8C00)),
                          ),
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
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
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
            color: Colors.grey[900]?.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.withOpacity(0.5)),
                    ),
                    child: Text(
                      'in $timeLeft',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Color(0xFFFF8C00)),
                  const SizedBox(width: 6),
                  Text(
                    organizer,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFFF8C00),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: participants
                    .split(', ')
                    .map((name) => _buildParticipant(name, theme))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipant(String name, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollableEventCards(ThemeData theme, bool isDarkMode,
      {required bool isCreatedEvents}) {
    List<Map<String, String>> events = [
      {
        'title': 'Longlegs',
        'date': '22/08/2024',
        'time': '14:00',
        'accepted': 'Geeneth',
      },
      {
        'title': 'D&D Session',
        'date': '25/08/2024',
        'time': '20:00',
        'accepted': 'Nethma, Amantha',
      },
      {
        'title': 'Movie Night',
        'date': '30/08/2024',
        'time': '19:30',
        'accepted': 'Dimantha, Hakkam',
      },
    ];

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _buildEventCardSmall(
          title: events[index]['title']!,
          date: events[index]['date']!,
          time: events[index]['time']!,
          accepted: events[index]['accepted']!,
          theme: theme,
          isDarkMode: isDarkMode,
          cardColor: isCreatedEvents
              ? (isDarkMode ? const Color(0xFF2E7D32) : const Color(0xFFA5D6A7))
              : (isDarkMode
                  ? const Color(0xFF1565C0)
                  : const Color(0xFF90CAF9)),
          textColor: Colors.white,
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
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '$date | $time',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFFFF8C00).withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: accepted
                .split(', ')
                .map((name) => _buildParticipant(name, theme))
                .toList(),
          ),
        ],
      ),
    );
  }
}
