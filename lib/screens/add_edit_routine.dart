import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_flow/models/routine_item.dart';
import 'package:daily_flow/providers/routine_provider.dart';
import 'package:intl/intl.dart';

class AddEditRoutineScreen extends ConsumerStatefulWidget {
  final RoutineItem? routine;

  const AddEditRoutineScreen({this.routine, super.key});

  @override
  ConsumerState<AddEditRoutineScreen> createState() => _AddEditRoutineScreenState();
}

class _AddEditRoutineScreenState extends ConsumerState<AddEditRoutineScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TimeOfDay _selectedTime;
  late Recurrence _recurrence;
  late List<int> _selectedWeekdays;
  late int _reminderMinutes;
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final routine = widget.routine;
    _titleController = TextEditingController(text: routine?.title ?? '');
    _descriptionController = TextEditingController(text: routine?.description ?? '');
    _selectedTime = routine != null
        ? TimeOfDay.fromDateTime(routine.time)
        : TimeOfDay.now();
    _recurrence = routine?.recurrence ?? Recurrence.none;
    _selectedWeekdays = routine?.weekdays ?? [];
    _reminderMinutes = routine?.reminderMinutesBefore ?? 0;
    _isEnabled = routine?.enabled ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine == null ? 'Add Routine' : 'Edit Routine'),
        actions: [
          if (widget.routine != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteRoutine,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Time'),
              subtitle: Text(
                _selectedTime.format(context),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: _selectTime,
              trailing: const Icon(Icons.access_time),
            ),
            const Divider(),
            ListTile(
              title: const Text('Recurrence'),
              subtitle: DropdownButton<Recurrence>(
                value: _recurrence,
                isExpanded: true,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _recurrence = value);
                  }
                },
                items: Recurrence.values.map((recurrence) {
                  return DropdownMenuItem(
                    value: recurrence,
                    child: Text(_getRecurrenceText(recurrence)),
                  );
                }).toList(),
              ),
            ),
            if (_recurrence == Recurrence.weekly)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  children: _buildWeekdayChips(),
                ),
              ),
            const Divider(),
            ListTile(
              title: const Text('Reminder'),
              subtitle: DropdownButton<int>(
                value: _reminderMinutes,
                isExpanded: true,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _reminderMinutes = value);
                  }
                },
                items: [0, 5, 10, 15, 30, 60].map((minutes) {
                  return DropdownMenuItem(
                    value: minutes,
                    child: Text(minutes == 0
                        ? 'At time of routine'
                        : '$minutes minutes before'),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Enabled'),
              value: _isEnabled,
              onChanged: (value) {
                setState(() => _isEnabled = value);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveRoutine,
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  List<Widget> _buildWeekdayChips() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return List.generate(7, (index) {
      final weekday = index + 1;
      return FilterChip(
        selected: _selectedWeekdays.contains(weekday),
        label: Text(weekdays[index]),
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedWeekdays.add(weekday);
            } else {
              _selectedWeekdays.remove(weekday);
            }
          });
        },
      );
    });
  }

  String _getRecurrenceText(Recurrence recurrence) {
    switch (recurrence) {
      case Recurrence.none:
        return 'One-time';
      case Recurrence.daily:
        return 'Daily';
      case Recurrence.weekly:
        return 'Weekly';
      case Recurrence.custom:
        return 'Custom';
    }
  }

  void _saveRoutine() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    if (_recurrence == Recurrence.weekly && _selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one weekday')),
      );
      return;
    }

    final now = DateTime.now();
    final routineTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final routine = RoutineItem(
      id: widget.routine?.id,
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      time: routineTime,
      enabled: _isEnabled,
      recurrence: _recurrence,
      weekdays: _recurrence == Recurrence.weekly ? _selectedWeekdays : null,
      reminderMinutesBefore: _reminderMinutes,
    );

    if (widget.routine == null) {
      ref.read(routineProvider.notifier).addRoutine(routine);
    } else {
      ref.read(routineProvider.notifier).updateRoutine(routine);
    }

    Navigator.pop(context);
  }

  void _deleteRoutine() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Routine'),
        content: const Text('Are you sure you want to delete this routine?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(routineProvider.notifier).deleteRoutine(widget.routine!.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close screen
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}