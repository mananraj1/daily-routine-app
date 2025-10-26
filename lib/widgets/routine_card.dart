import 'package:flutter/material.dart';
import 'package:daily_flow/models/routine_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_flow/providers/routine_provider.dart';
import 'package:animations/animations.dart';
import 'package:intl/intl.dart';

class RoutineCard extends ConsumerWidget {
  final RoutineItem routine;
  final VoidCallback onTap;

  const RoutineCard({
    super.key,
    required this.routine,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFormat = DateFormat('HH:mm');
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        openBuilder: (context, _) {
          onTap();
          return const SizedBox.shrink();
        },
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        closedBuilder: (context, openContainer) => Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: openContainer,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeFormat.format(routine.time),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Switch(
                        value: routine.enabled,
                        onChanged: (value) {
                          ref.read(routineProvider.notifier).toggleRoutine(routine.id);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    routine.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (routine.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      routine.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildChip(context, _getRecurrenceText(routine.recurrence)),
                      if (routine.reminderMinutesBefore > 0) ...[
                        const SizedBox(width: 8),
                        _buildChip(
                          context,
                          'Remind ${routine.reminderMinutesBefore}m before',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: 12,
        ),
      ),
    );
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
}