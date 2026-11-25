import 'package:flutter/material.dart';

import '../models/task_item.dart';

class TaskTileCard extends StatelessWidget {
  final TaskItem task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;

  const TaskTileCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Tinggi':
        return const Color(0xFFEF4444);
      case 'Sedang':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prioColor = _getPriorityColor(task.priority);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Checkbox(
          value: task.isCompleted,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          onChanged: onToggle,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.category,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: prioColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.priority,
                  style: TextStyle(
                    fontSize: 11,
                    color: prioColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.redAccent,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
