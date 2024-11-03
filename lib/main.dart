import 'package:flutter/material.dart';
import 'package:front_end_task/event_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Event Listing',
      theme: ThemeData(primarySwatch: Colors.red),
      home: EventListPage(),
    );
  }
}

