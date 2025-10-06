import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:remindly/models/special_date.dart';
import 'package:remindly/services/notification_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  late DateTime _selectedDate;
  String _selectedType = 'Birthday';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(
      const Duration(days: 30),
    ); // Default: 30 days from now
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<SpecialDate>('special_dates');
      final newEvent = SpecialDate(
        name: _nameController.text,
        date: _selectedDate,
        type: _selectedType,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      box.add(newEvent);

      // Schedule notification for 1 day before
      final reminderDate = _selectedDate.subtract(const Duration(days: 1));
      NotificationService.showReminder(
        id: newEvent.key as int,
        title: 'Upcoming Special Date',
        body: 'Tomorrow is ${newEvent.name}!',
        scheduledDate: reminderDate,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Special Date')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ['Birthday', 'Anniversary', 'Holiday', 'Custom']
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Date: ${DateFormat.yMMMMd().format(_selectedDate)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'e.g., Loves chocolate',
                ),
                maxLines: 2,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveEvent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Save Event', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
