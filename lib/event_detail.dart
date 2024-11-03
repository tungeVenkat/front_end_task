import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventDetailPage extends StatefulWidget {
  final Map<String, String> event;

  EventDetailPage({required this.event});

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final List<Map<String, String>> attendees = [];
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _errorMessage;

  Future<void> _rsvp() async {
    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      final apiUrl = 'https://jsonplaceholder.typicode.com/posts';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "name": _nameController.text,
            "email": _emailController.text,
            "eventTitle": widget.event["title"],
          }),
        );

        if (response.statusCode == 201) {
          setState(() {
            attendees.add({
              "name": _nameController.text,
              "email": _emailController.text,
            });
            _errorMessage = null;
          });
          _nameController.clear();
          _emailController.clear();
        } else {
          setState(() {
            _errorMessage = 'Failed to RSVP: ${response.body}';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Network error: Please try again later.';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please fill in both fields.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.event["title"] ?? "Event Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${widget.event["date"]}",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              widget.event["description"] ?? "No Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(height: 30, color: Colors.black),
            _buildRSVPSection(),
            Divider(height: 30, color: Colors.grey[400]),
            Text("Attendees",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildAttendeesList(),
          ],
        ),
      ),
      backgroundColor: Colors.blue[200],
    );
  }

  Widget _buildRSVPSection() {
    return Container(
      
      width: 400,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("RSVP to this event",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          if (_errorMessage != null) ...[
            Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
          ],
          TextField(
            controller: _nameController,
            decoration: _inputDecoration("Name"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: _inputDecoration("Email"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: _rsvp,
            child: Text(
              "RSVP",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildAttendeesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: attendees.length,
      itemBuilder: (context, index) {
        final attendee = attendees[index];
        return Container(
          width: 400,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 1,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: ListTile(
            title: Text(attendee["name"]!,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(attendee["email"]!),
          ),
        );
      },
    );
  }
}
