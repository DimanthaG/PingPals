import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PingPals!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 149, 0),
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
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
              ),

              // Pinned Events Section
              SizedBox(height: 20),
              Text(
                'Pinned Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 30.0),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(87, 101, 242, 1),
                        borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.discord, size: 40, color: Colors.white),
                          Spacer(),
                          Text(
                            'Clubhouse',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Deal!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 220.0),
                          child: Text(
                            'in 12:22',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Geeneth Kulutunge',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                              
                              
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          'Amantha',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          'Dimantha',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          'Hakkam',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          'Nethma',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 60.0), // Adjust the left padding value as needed
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            'Thulana',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            'Geeneth',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            'Sheveen',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            'Autism',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.location_on, color: Colors.amber[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0), // Add padding around the container
                      child: Container(
                        padding: EdgeInsets.only(left: 20,top: 8,right:20 ,bottom: 8), // Inner padding of the container
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          
                        ),
                        
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(text: "Hey, I'll be a few minutes late"),
                                 style: TextStyle(
                                  fontSize: 14, // Adjust the font size as needed
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Icon(Icons.send, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              // Upcoming Events Section
              SizedBox(height: 20),
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: EventCard(
                  title: 'Deal!',
                  organizer: 'Geeneth Kulutunge',
                  timeLeft: '12:22',
                  participants: 'Nethma, Amantha, Dimantha, Hakkam',
                ),
              ),
              Container(
                width: double.infinity,
                child: EventCard(
                  title: 'QuickWit',
                  organizer: 'Roosanda',
                  timeLeft: '1:30:12',
                  participants: 'Nethma, Amantha, Dimantha',
                ),
              ),
              Container(
                width: double.infinity,
                child: EventCard(
                  title: 'Minecraft',
                  organizer: 'DimanthaG',
                  timeLeft: '20:32',
                  participants: 'Nethma',
                ),
              ),

              // Invited Events Section
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Text(
                  'Invited Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: EventCardSmall(
                  title: 'Longlegs',
                  date: '22/08/2024',
                  time: '14:00',
                  accepted: 'Geeneth',
                ),
              ),
              Container(
                width: double.infinity,
                child: EventCardSmall(
                  title: 'Longlegs',
                  date: '22/08/2024',
                  time: '14:00',
                  accepted: 'Geeneth',
                ),
              ),

              // Created Events Section
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Text(
                  'Created Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: EventCardSmall(
                  title: 'Longlegs',
                  date: '22/08/2024',
                  time: '14:00',
                  accepted: 'Geeneth',
                ),
              ),
              Container(
                width: double.infinity,
                child: EventCardSmall(
                  title: 'Longlegs',
                  date: '22/08/2024',
                  time: '14:00',
                  accepted: 'Geeneth',
                ),
              ),

              // Invited Events Section
              SizedBox(height: 20),
              Text(
                'Invited Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              EventCardSmall(
                title: 'Longlegs',
                date: '22/08/2024',
                time: '14:00',
                accepted: 'Geeneth',
              ),
              EventCardSmall(
                title: 'Longlegs',
                date: '22/08/2024',
                time: '14:00',
                accepted: 'Geeneth',
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
              EventCardSmall(
                title: 'Longlegs',
                date: '22/08/2024',
                time: '14:00',
                accepted: 'Geeneth',
              ),
              EventCardSmall(
                title: 'Longlegs',
                date: '22/08/2024',
                time: '14:00',
                accepted: 'Geeneth',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Event Card Widget for Upcoming Events
class EventCard extends StatelessWidget {
  final String title;
  final String organizer;
  final String timeLeft;
  final String participants;

  const EventCard({
    super.key,
    required this.title,
    required this.organizer,
    required this.timeLeft,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            organizer,
            style: TextStyle(color: Colors.orange),
          ),
          Text(
            participants,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          Text(
            'in $timeLeft',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Event Card Widget for Invited/Created Events
class EventCardSmall extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String accepted;

  const EventCardSmall({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.accepted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            '$date $time',
            style: TextStyle(color: Colors.orange),
          ),
          SizedBox(height: 10),
          Text(
            'Accepted: $accepted',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
