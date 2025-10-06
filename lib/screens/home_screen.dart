import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:remindly/models/special_date.dart';
import 'package:remindly/screens/add_event_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Special Dates')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AddEventScreen())),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<SpecialDate>('special_dates').listenable(),
        builder: (context, Box<SpecialDate> box, _) {
          final events = box.values.toList()
            ..sort((a, b) => a.date.compareTo(b.date));

          // Filter upcoming events (next 365 days)
          final now = DateTime.now();
          final nextYear = now.add(const Duration(days: 365));
          final upcoming = events
              .where(
                (e) =>
                    e.date.isAfter(now.subtract(const Duration(days: 1))) &&
                    e.date.isBefore(nextYear),
              )
              .toList();

          if (upcoming.isEmpty) {
            return const Center(
              child: Text('No upcoming special dates.\nTap + to add one!'),
            );
          }

          return ListView.builder(
            itemCount: upcoming.length,
            itemBuilder: (context, index) {
              final event = upcoming[index];
              final isToday = _isSameDay(event.date, DateTime.now());

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isToday ? Colors.purple[50] : null,
                child: ListTile(
                  title: Text(event.name),
                  subtitle: Text(
                    '${event.type} • ${DateFormat.yMMMMd().format(event.date)}',
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? Colors.purple : null,
                    ),
                  ),
                  trailing: Text(
                    isToday ? 'TODAY!' : _daysUntil(event.date),
                    style: TextStyle(
                      color: isToday ? Colors.red : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _daysUntil(DateTime eventDate) {
    final now = DateTime.now();
    final eventThisYear = DateTime(now.year, eventDate.month, eventDate.day);
    final eventNextYear = DateTime(
      now.year + 1,
      eventDate.month,
      eventDate.day,
    );

    DateTime upcomingEventDate;
    if (eventThisYear.isAfter(now)) {
      upcomingEventDate = eventThisYear;
    } else {
      upcomingEventDate = eventNextYear;
    }

    final difference = upcomingEventDate.difference(now).inDays;
    return '$difference days';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
