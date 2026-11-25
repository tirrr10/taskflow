import 'package:flutter/material.dart';

import '../models/task_item.dart';

class TaskFlowNotifier extends ChangeNotifier {
  final List<TaskItem> _tasks = [
    TaskItem(
      id: '1',
      title: 'Selesaikan wireframe UI/UX TaskFlow',
      category: 'Desain',
      priority: 'Tinggi',
      isCompleted: true,
    ),
    TaskItem(
      id: '2',
      title: 'Slicing komponen card & modal input',
      category: 'Dev',
      priority: 'Tinggi',
      isCompleted: false,
    ),
    TaskItem(
      id: '3',
      title: 'Review alur interaksi tombol & error state',
      category: 'QA',
      priority: 'Sedang',
      isCompleted: false,
    ),
  ];

  String _selectedFilter = 'Semua';

  List<TaskItem> get allTasks => List.unmodifiable(_tasks);
  String get selectedFilter => _selectedFilter;

  List<TaskItem> get filteredTasks {
    if (_selectedFilter == 'Aktif') {
      return _tasks.where((t) => !t.isCompleted).toList();
    } else if (_selectedFilter == 'Selesai') {
      return _tasks.where((t) => t.isCompleted).toList();
    }
    return _tasks;
  }

  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get totalCount => _tasks.length;
  double get progress => totalCount == 0 ? 0.0 : completedCount / totalCount;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void toggleTaskCompletion(String id, bool value) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = value;
      notifyListeners();
    }
  }

  String? addTask({
    required String title,
    required String category,
    required String priority,
  }) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return 'Nama tugas tidak boleh kosong!';
    }
    if (trimmed.length < 3) {
      return 'Minimal 3 karakter ya!';
    }
    final isDuplicate = _tasks.any(
      (t) => t.title.toLowerCase() == trimmed.toLowerCase(),
    );
    if (isDuplicate) {
      return 'Tugas "$trimmed" sudah ada di daftar!';
    }

    _tasks.insert(
      0,
      TaskItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: trimmed,
        category: category,
        priority: priority,
      ),
    );
    notifyListeners();
    return null;
  }

  String? deleteTask(TaskItem task) {
    if (task.priority == 'Tinggi' && !task.isCompleted) {
      return 'Selesaikan dulu tugas prioritas Tinggi sebelum menghapus!';
    }
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
    return null;
  }

  String? clearCompletedTasks() {
    if (completedCount == 0) {
      return 'Tidak ada tugas selesai yang bisa dibersihkan!';
    }
    _tasks.removeWhere((t) => t.isCompleted);
    notifyListeners();
    return null;
  }
}
