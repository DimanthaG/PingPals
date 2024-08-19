import 'package:flutter/material.dart';
import 'package:pingpal/src/widgets/event_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PingPals',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to profile or settings page
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
              // Accepted Events Section
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              EventCard(
                title: 'Deal',
                organizer: 'Geen',
                timeLeft: '2:12:45',
              ),
              EventCard(
                title: 'One Piece Watch Party!!',
                organizer: 'NethmaDS',
                timeLeft: '1:15:22',
              ),
              SizedBox(height: 20),

              // Invited Events Section
              Text(
                'Invited Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 150, // Set a fixed height for horizontal scrolling
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    EventCard(
                      title: 'Event 1',
                      organizer: 'Organizer 1',
                      timeLeft: '3 days',
                    ),
                    SizedBox(width: 10),
                    EventCard(
                      title: 'Event 2',
                      organizer: 'Organizer 2',
                      timeLeft: '5 days',
                    ),
                    EventCard(
                      title: 'Event 3',
                      organizer: 'Organizer 3',
                      timeLeft: '5 days',
                    ),
                    EventCard(
                      title: 'Event 4',
                      organizer: 'Organizer 5',
                      timeLeft: '5 days',
                    ),
                    // Add more EventCard widgets as needed
                  ],
                ),
              ),

              // Created Events Section
              SizedBox(height: 20),
              Text(
                'Created Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 150, // Set a fixed height for horizontal scrolling
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    EventCard(
                      title: 'Event 1',
                      organizer: 'Organizer 3',
                      timeLeft: '1 day',
                    ),
                    SizedBox(width: 10),
                    EventCard(
                      title: 'Event 2',
                      organizer: 'Organizer 4',
                      timeLeft: '2 days',
                    ),
                    // Add more EventCard widgets as needed
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
