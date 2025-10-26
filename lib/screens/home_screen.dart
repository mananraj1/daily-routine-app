import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_flow/models/routine_item.dart';
import 'package:daily_flow/providers/routine_provider.dart';
import 'package:daily_flow/widgets/routine_card.dart';
import 'package:daily_flow/screens/add_edit_routine.dart';
import 'package:daily_flow/screens/settings_screen.dart';
import 'package:animations/animations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayRoutines = ref.watch(routineProvider.notifier).getTodayRoutines();
    final upcomingRoutines = ref.watch(routineProvider.notifier).getUpcomingRoutines();

    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          _buildRoutineSection(
            context,
            'Today',
            todayRoutines,
          ),
          _buildRoutineSection(
            context,
            'Upcoming',
            upcomingRoutines.where((r) => !todayRoutines.contains(r)).toList(),
          ),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        openBuilder: (context, _) => AddEditRoutineScreen(),
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        closedBuilder: (context, openContainer) => FloatingActionButton(
          onPressed: openContainer,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildRoutineSection(
    BuildContext context,
    String title,
    List<RoutineItem> routines,
  ) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        if (routines.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No routines scheduled',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final routine = routines[index];
                return RoutineCard(
                  routine: routine,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditRoutineScreen(routine: routine),
                      ),
                    );
                  },
                );
              },
              childCount: routines.length,
            ),
          ),
      ],
    );
  }
}