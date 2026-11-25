import 'package:flutter/material.dart';

import '../controllers/task_flow_notifier.dart';
import '../utils/app_snackbar.dart';
import '../widgets/add_task_modal.dart';
import '../widgets/progress_summary_card.dart';
import '../widgets/task_tile_card.dart';

class TaskFlowHomeScreen extends StatefulWidget {
  const TaskFlowHomeScreen({super.key});

  @override
  State<TaskFlowHomeScreen> createState() => _TaskFlowHomeScreenState();
}

class _TaskFlowHomeScreenState extends State<TaskFlowHomeScreen> {
  final TaskFlowNotifier _notifier = TaskFlowNotifier();

  @override
  void initState() {
    super.initState();
    _notifier.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    _notifier.dispose();
    super.dispose();
  }

  void _openAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.blueAccent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return AddTaskModal(
          onSubmitTask: _notifier.addTask,
          onNotify: (msg, {bool isError = false}) {
            AppSnackbar.show(context, msg, isError: isError);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _notifier.filteredTasks;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'TaskFlow',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Bersihkan tugas selesai',
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: () {
              final countBefore = _notifier.completedCount;
              final error = _notifier.clearCompletedTasks();
              if (error != null) {
                AppSnackbar.show(context, 'Error: $error', isError: true);
                return;
              }
              AppSnackbar.show(
                context,
                '$countBefore tugas selesai dibersihkan.',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            ProgressSummaryCard(
              completedCount: _notifier.completedCount,
              totalCount: _notifier.totalCount,
              progress: _notifier.progress,
            ),
            const SizedBox(height: 24),
            Row(
              children: ['Semua', 'Aktif', 'Selesai'].map((filter) {
                final isSelected = _notifier.selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => _notifier.setFilter(filter),
                    selectedColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    labelStyle: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada tugas di kategori "${_notifier.selectedFilter}"',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskTileCard(
                          task: task,
                          onToggle: (val) {
                            _notifier.toggleTaskCompletion(
                              task.id,
                              val ?? false,
                            );
                          },
                          onDelete: () {
                            final error = _notifier.deleteTask(task);
                            if (error != null) {
                              AppSnackbar.show(
                                context,
                                'Error: $error',
                                isError: true,
                              );
                              return;
                            }
                            AppSnackbar.show(context, 'Tugas dihapus.');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskModal,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Tugas',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
