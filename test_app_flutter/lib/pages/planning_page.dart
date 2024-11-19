import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PlanningPage extends StatefulWidget {
  @override
  _PlanningPageState createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    final String response = await rootBundle.loadString('assets/events.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      events = data.map((event) {
        return {
          "time": event["time"],
          "title": event["title"],
          "location": event["location"],
          "color": Color(int.parse(event["color"].substring(1, 7), radix: 16) + 0xFF000000),
          "startHour": event["startHour"],
          "duration": event["duration"]
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planning')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(10, (index) {
              int hour = 9 + index;
              List<Map<String, dynamic>> eventsAtHour = events.where((event) => event['startHour'] == hour).toList();

              return Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: Text(
                        '${hour.toString().padLeft(2, '0')}:00',
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: eventsAtHour.map((event) {
                            return Container(
                              width: eventsAtHour.length > 1 ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.8,
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              child: EventCard(
                                time: event['time'],
                                title: event['title'],
                                location: event['location'],
                                color: event['color'],
                                height: 100.0 * (event['duration'] as int).toDouble(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String time;
  final String title;
  final String location;
  final Color color;
  final double height;

  EventCard({required this.time, required this.title, required this.location, required this.color, required this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color.withOpacity(0.1),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text(
              location,
              style: TextStyle(fontSize: 12.0, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}