import 'package:flutter/material.dart';
import 'package:front_end_task/event_detail.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final List<Map<String, String>> events = [
    {
      "title": "Flutter Workshop",
      "date": "2024-11-15 10:00 AM",
      "description": "Learn Flutter basics and build your first app."
    },
    {
      "title": "Code Meetup",
      "date": "2024-12-20 04:00 PM",
      "description": "Meet other developers and share coding tips."
    },
    {
      "title": "Help",
      "date": "2024-12-30 07:00 PM",
      "description": "Meet class to help freshers."
    },
    {
      "title": "Movie Meetup",
      "date": "2025-01-20 04:00 PM",
      "description": "Meet influencers to promote movie."
    },
  ];

  void _navigateToEventDetail(BuildContext context, Map<String, String> event) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EventDetailPage(event: event),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.person),
        title: Text("Event Listing", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: events.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _navigateToEventDetail(context, events[index]),
          child: EventCard(event: events[index]),
        ),
      ),
      backgroundColor: Colors.blue[200],
    );
  }
}

class EventCard extends StatelessWidget {
  final Map<String, String> event;

  const EventCard({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event["title"]!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text("Date: ${event["date"]}"),
            SizedBox(height: 10),
            Text(event["description"]!),
          ],
        ),
      ),
    );
  }
}
