import 'package:flutter/material.dart';
import 'package:polaroid_journal/screens/jounrnal_entry.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Journal')),
      body: Center(child: Text('No entries yet')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => JournalEntryScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
