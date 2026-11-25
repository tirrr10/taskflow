class TaskItem {
  final String id;
  String title;
  String category;
  String priority;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    this.isCompleted = false,
  });
}
